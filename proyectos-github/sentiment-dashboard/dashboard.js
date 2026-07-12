/**
 * Sentiment Dashboard - Real-time crypto market sentiment analysis.
 * Uses CoinGecko API for prices/trending, alternative.me for Fear & Greed.
 * Fully client-side, data cached via localStorage.
 */

const CACHE_KEY = "sentiment_dashboard_cache";
const CACHE_TTL = 5 * 60 * 1000; // 5 minutes

function getCache() {
    try {
        const raw = localStorage.getItem(CACHE_KEY);
        if (!raw) return null;
        const data = JSON.parse(raw);
        if (Date.now() - data.ts > CACHE_TTL) return null;
        return data;
    } catch { return null; }
}

function setCache(data) {
    try {
        localStorage.setItem(CACHE_KEY, JSON.stringify({ ts: Date.now(), ...data }));
    } catch { /* quota exceeded */ }
}

function toast(msg) {
    const el = document.createElement("div");
    el.className = "toast";
    el.textContent = msg;
    document.body.appendChild(el);
    setTimeout(() => el.remove(), 3100);
}

async function fetchJSON(url) {
    const resp = await fetch(url);
    if (!resp.ok) throw new Error(`HTTP ${resp.status}`);
    return resp.json();
}

// ========================
// Fear & Greed Index
// ========================
async function loadFearGreed() {
    const cache = getCache();
    if (cache && cache.fearGreed) return cache.fearGreed;

    const data = await fetchJSON("https://api.alternative.me/fng/?limit=1");
    const item = data.data[0];
    const result = {
        value: parseInt(item.value),
        classification: item.value_classification,
    };
    setCache({ ...getCache(), fearGreed: result, ts: Date.now() });
    return result;
}

function renderFearGreed(fg) {
    const el = document.getElementById("fg-value");
    const label = document.getElementById("fg-label");
    const pointer = document.getElementById("fg-pointer");
    const timestamp = document.getElementById("fg-timestamp");

    el.textContent = fg.value;

    if (fg.value <= 25) el.style.color = "var(--accent-red)";
    else if (fg.value <= 45) el.style.color = "var(--accent-orange)";
    else if (fg.value <= 55) el.style.color = "var(--accent-yellow)";
    else el.style.color = "var(--accent-green)";

    label.textContent = fg.classification;
    pointer.style.left = fg.value + "%";
    timestamp.textContent = "Updated just now";
}

// ========================
// Top trending coins
// ========================
async function loadTrending() {
    const cache = getCache();
    if (cache && cache.trending) return cache.trending;

    const data = await fetchJSON("https://api.coingecko.com/api/v3/search/trending");
    const coins = data.coins.slice(0, 10).map((c) => ({
        name: c.item.name,
        symbol: c.item.symbol.toUpperCase(),
        market_cap_rank: c.item.market_cap_rank,
        price_btc: c.item.price_btc,
        score: c.item.score,
        icon: c.item.thumb,
    }));

    // Get 24h change data
    try {
        const ids = data.coins.slice(0, 10).map((c) => c.item.id).join(",");
        const prices = await fetchJSON(
            `https://api.coingecko.com/api/v3/simple/price?ids=${ids}&vs_currencies=usd&include_24hr_change=true`
        );
        coins.forEach((c) => {
            const id = data.coins.find((x) => x.item.symbol.toUpperCase() === c.symbol)?.item.id;
            if (id && prices[id]) {
                c.price_usd = prices[id].usd;
                c.change_24h = prices[id].usd_24h_change;
            }
        });
    } catch { /* ok, skip price data */ }

    setCache({ ...getCache(), trending: coins, ts: Date.now() });
    return coins;
}

function getSentimentClass(score) {
    if (score >= 80) return "bullish";
    if (score >= 40) return "neutral";
    return "bearish";
}

function getSentimentLabel(score) {
    if (score >= 80) return "Strong Buy";
    if (score >= 60) return "Buy";
    if (score >= 40) return "Neutral";
    return "Weak";
}

function renderTrending(coins) {
    const tbody = document.querySelector("#trending-table tbody");
    tbody.innerHTML = "";

    coins.forEach((c) => {
        const rank = c.market_cap_rank || "?";
        const price = c.price_usd ? `$${c.price_usd.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 6 })}` : "N/A";
        const change = c.change_24h != null ? `${c.change_24h >= 0 ? "+" : ""}${c.change_24h.toFixed(2)}%` : "N/A";
        const changeClass = c.change_24h >= 0 ? "positive" : "negative";
        const sentiment = getSentimentLabel(c.score);

        const tr = document.createElement("tr");
        tr.innerHTML = `
            <td>
                <div class="coin-name-col">
                    <div class="coin-icon">${c.symbol.slice(0, 2)}</div>
                    <div>
                        <div style="font-weight:600">${c.name}</div>
                        <div style="font-size:0.7rem;color:var(--text-secondary)">${c.symbol}</div>
                    </div>
                </div>
            </td>
            <td>#${rank}</td>
            <td>${price}</td>
            <td class="${changeClass}">${change}</td>
            <td><span class="sentiment-badge ${getSentimentClass(c.score)}">${sentiment}</span></td>
        `;
        tbody.appendChild(tr);
    });

    document.getElementById("trending-timestamp").textContent = "Updated just now";
}

// ========================
// Price Ticker
// ========================
async function loadTicker() {
    const cache = getCache();
    if (cache && cache.ticker) return cache.ticker;

    const data = await fetchJSON(
        "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=1&sparkline=false&price_change_percentage=24h"
    );
    const result = data.map((c) => ({
        name: c.name,
        symbol: c.symbol.toUpperCase(),
        price: c.current_price,
        change_24h: c.price_change_percentage_24h,
    }));
    setCache({ ...getCache(), ticker: result, ts: Date.now() });
    return result;
}

function renderTicker(coins) {
    const ticker = document.getElementById("ticker");
    // Duplicate for seamless scroll
    const items = [...coins, ...coins]
        .map((c) => {
            const chg = c.change_24h != null ? c.change_24h.toFixed(2) : "0.00";
            const cls = parseFloat(chg) >= 0 ? "positive" : "negative";
            const sign = parseFloat(chg) >= 0 ? "+" : "";
            const priceStr = c.price >= 1 ? c.price.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })
                : c.price.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 6 });
            return `<div class="ticker-item">
                <span class="name">${c.symbol}</span>
                <span class="price">$${priceStr}</span>
                <span class="change ${cls}">${sign}${chg}%</span>
            </div>`;
        })
        .join("");
    ticker.innerHTML = items;
}

// ========================
// Market metrics
// ========================
async function loadGlobalData() {
    const cache = getCache();
    if (cache && cache.global) return cache.global;

    const data = await fetchJSON("https://api.coingecko.com/api/v3/global");
    const d = data.data;
    const result = {
        total_market_cap: d.total_market_cap.usd,
        total_volume: d.total_volume.usd,
        btc_dominance: d.market_cap_percentage.btc,
        eth_dominance: d.market_cap_percentage.eth,
        active_cryptos: d.active_cryptocurrencies,
        market_cap_change_24h: d.market_cap_change_percentage_24h_usd,
    };
    setCache({ ...getCache(), global: result, ts: Date.now() });
    return result;
}

function renderGlobalMetrics(g) {
    const fmtUSD = (v) => {
        if (v >= 1e12) return `$${(v / 1e12).toFixed(2)}T`;
        if (v >= 1e9) return `$${(v / 1e9).toFixed(2)}B`;
        return `$${(v / 1e6).toFixed(1)}M`;
    };

    document.getElementById("metric-mcap").textContent = fmtUSD(g.total_market_cap);
    document.getElementById("metric-volume").textContent = fmtUSD(g.total_volume);
    document.getElementById("metric-btc-dom").textContent = g.btc_dominance.toFixed(1) + "%";
    document.getElementById("metric-eth-dom").textContent = g.eth_dominance.toFixed(1) + "%";
    document.getElementById("metric-cryptos").textContent = g.active_cryptos.toLocaleString();

    const mcapChange = document.getElementById("metric-mcap-change");
    mcapChange.textContent = `${g.market_cap_change_24h >= 0 ? "+" : ""}${g.market_cap_change_24h.toFixed(2)}%`;
    mcapChange.style.color = g.market_cap_change_24h >= 0 ? "var(--accent-green)" : "var(--accent-red)";

    // Dominance bars
    const otherDom = 100 - g.btc_dominance - g.eth_dominance;
    document.getElementById("dom-btc-bar").style.width = g.btc_dominance + "%";
    document.getElementById("dom-btc-val").textContent = g.btc_dominance.toFixed(1) + "%";
    document.getElementById("dom-eth-bar").style.width = g.eth_dominance + "%";
    document.getElementById("dom-eth-val").textContent = g.eth_dominance.toFixed(1) + "%";
    document.getElementById("dom-other-bar").style.width = otherDom + "%";
    document.getElementById("dom-other-val").textContent = otherDom.toFixed(1) + "%";
}

// ========================
// Chart: Top 10 market cap pie
// ========================
let chartPie = null;
async function renderTop10Pie() {
    try {
        const data = await fetchJSON(
            "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=false"
        );
        const othersMcap = data.slice(5).reduce((s, c) => s + c.market_cap, 0);
        const labels = data.slice(0, 5).map((c) => c.symbol.toUpperCase());
        labels.push("Others");
        const values = data.slice(0, 5).map((c) => c.market_cap);
        values.push(othersMcap);

        const ctx = document.getElementById("chart-pie").getContext("2d");
        if (chartPie) chartPie.destroy();
        chartPie = new Chart(ctx, {
            type: "doughnut",
            data: {
                labels,
                datasets: [{
                    data: values,
                    backgroundColor: ["#f0883e", "#a371f7", "#58a6ff", "#3fb950", "#d2991d",
                        "rgba(139,148,158,0.5)"],
                    borderColor: "var(--bg-card)",
                    borderWidth: 2,
                }],
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { position: "bottom", labels: { color: "#8b949e", padding: 14, font: { size: 11 } } },
                },
            },
        });
    } catch { /* ignore */ }
}

// ========================
// Chart: 7-day BTC price
// ========================
let chartLine = null;
async function renderBTCChart() {
    try {
        const data = await fetchJSON(
            "https://api.coingecko.com/api/v3/coins/bitcoin/market_chart?vs_currency=usd&days=7"
        );
        const labels = data.prices.map((p) => {
            const d = new Date(p[0]);
            return d.toLocaleDateString("en-US", { month: "short", day: "numeric" });
        });
        const prices = data.prices.map((p) => p[1]);

        const ctx = document.getElementById("chart-line").getContext("2d");
        if (chartLine) chartLine.destroy();
        chartLine = new Chart(ctx, {
            type: "line",
            data: {
                labels,
                datasets: [{
                    label: "BTC/USD",
                    data: prices,
                    borderColor: "#f0883e",
                    backgroundColor: "rgba(240,136,62,0.08)",
                    fill: true,
                    tension: 0.4,
                    pointRadius: 0,
                    borderWidth: 2,
                }],
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                },
                scales: {
                    x: { ticks: { color: "#8b949e", maxTicksLimit: 7, font: { size: 10 } }, grid: { color: "rgba(48,54,61,0.4)" } },
                    y: { ticks: { color: "#8b949e", callback: (v) => "$" + v.toLocaleString(), font: { size: 10 } }, grid: { color: "rgba(48,54,61,0.4)" } },
                },
                interaction: { intersect: false, mode: "index" },
            },
        });
    } catch { /* ignore */ }
}

// ========================
// Chart: Top gainers & losers
// ========================
let chartBar = null;
async function renderGainersLosers() {
    try {
        const data = await fetchJSON(
            "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=volume_desc&per_page=100&page=1&sparkline=false&price_change_percentage=24h"
        );
        const sorted = data.filter((c) => c.price_change_percentage_24h != null)
            .sort((a, b) => b.price_change_percentage_24h - a.price_change_percentage_24h);
        const top = sorted.slice(0, 5);
        const bottom = sorted.slice(-5).reverse();
        const combined = [...top, ...bottom];

        const labels = combined.map((c) => c.symbol.toUpperCase());
        const values = combined.map((c) => c.price_change_percentage_24h);
        const bgColors = values.map((v) => v >= 0 ? "rgba(63,185,80,0.7)" : "rgba(248,81,73,0.7)");

        const ctx = document.getElementById("chart-bar").getContext("2d");
        if (chartBar) chartBar.destroy();
        chartBar = new Chart(ctx, {
            type: "bar",
            data: {
                labels,
                datasets: [{ data: values, backgroundColor: bgColors, borderRadius: 4, borderWidth: 0 }],
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: { callbacks: { label: (ctx) => ctx.raw.toFixed(2) + "%" } },
                },
                scales: {
                    x: { ticks: { color: "#8b949e", font: { size: 11 } }, grid: { display: false } },
                    y: { ticks: { color: "#8b949e", callback: (v) => v + "%", font: { size: 10 } }, grid: { color: "rgba(48,54,61,0.4)" } },
                },
            },
        });
    } catch { /* ignore */ }
}

// ========================
// Volume trend chart (doughnut)
// ========================
let chartVolume = null;
async function renderVolumeByExchange() {
    try {
        const data = await fetchJSON("https://api.coingecko.com/api/v3/exchanges?per_page=6");
        const labels = data.map((e) => e.name);
        const values = data.map((e) => e.trade_volume_24h_btc);

        const ctx = document.getElementById("chart-donut").getContext("2d");
        if (chartVolume) chartVolume.destroy();
        chartVolume = new Chart(ctx, {
            type: "doughnut",
            data: {
                labels,
                datasets: [{
                    data: values,
                    backgroundColor: ["#58a6ff", "#3fb950", "#d2991d", "#f85149", "#a371f7", "#f0883e"],
                    borderColor: "var(--bg-card)",
                    borderWidth: 2,
                }],
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { position: "bottom", labels: { color: "#8b949e", padding: 10, font: { size: 10 } } },
                },
            },
        });
    } catch { /* ignore */ }
}

// ========================
// History chart
// ========================
let chartHistory = null;
async function renderHistoryChart() {
    try {
        const cache = getCache();
        let history = cache ? (cache.history || []) : [];
        const now = new Date().toLocaleTimeString("en-US", { hour: "2-digit", minute: "2-digit" });

        const fg = await fetchJSON("https://api.alternative.me/fng/?limit=1");
        const val = parseInt(fg.data[0].value);
        history.push({ time: now, value: val });
        if (history.length > 20) history.shift();

        setCache({ ...(getCache() || {}), history, ts: Date.now() });

        const labels = history.map((h) => h.time);
        const values = history.map((h) => h.value);

        const ctx = document.getElementById("chart-history").getContext("2d");
        if (chartHistory) chartHistory.destroy();
        chartHistory = new Chart(ctx, {
            type: "line",
            data: {
                labels,
                datasets: [{
                    label: "Fear & Greed",
                    data: values,
                    borderColor: "#a371f7",
                    backgroundColor: "rgba(163,113,247,0.1)",
                    fill: true,
                    tension: 0.3,
                    pointRadius: 3,
                    pointBackgroundColor: "#a371f7",
                    borderWidth: 2,
                }],
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    x: { ticks: { color: "#8b949e", font: { size: 10 } }, grid: { color: "rgba(48,54,61,0.4)" } },
                    y: { min: 0, max: 100, ticks: { color: "#8b949e", stepSize: 20, font: { size: 10 } }, grid: { color: "rgba(48,54,61,0.4)" } },
                },
            },
        });
    } catch { /* ignore */ }
}

// ========================
// Main loader
// ========================
async function loadAll() {
    const btn = document.getElementById("refresh-btn");
    btn.classList.add("spinning");
    btn.textContent = "Loading...";

    try {
        const [fg, trending, ticker, global] = await Promise.all([
            loadFearGreed(),
            loadTrending(),
            loadTicker(),
            loadGlobalData(),
        ]);

        renderFearGreed(fg);
        renderTrending(trending);
        renderTicker(ticker);
        renderGlobalMetrics(global);

        renderTop10Pie();
        renderBTCChart();
        renderGainersLosers();
        renderVolumeByExchange();
        renderHistoryChart();

        document.getElementById("last-update").textContent =
            new Date().toLocaleTimeString();
        toast("Data refreshed successfully");
    } catch (err) {
        console.error("Load error:", err);
        toast("Failed to load data. Using cached data if available.");
    } finally {
        btn.classList.remove("spinning");
        btn.textContent = "Refresh Data";
    }
}

// Auto-refresh every 5 minutes
setInterval(loadAll, 5 * 60 * 1000);

// Initial load
document.getElementById("refresh-btn").addEventListener("click", loadAll);
loadAll();
