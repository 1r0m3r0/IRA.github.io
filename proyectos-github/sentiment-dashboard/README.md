# Crypto Sentiment Dashboard

A real-time cryptocurrency market sentiment dashboard that runs entirely in the browser. Features the Fear & Greed Index, trending coins with sentiment indicators, live price ticker, interactive charts, and localStorage caching for offline access. No server required — just open `index.html`.

## Features

- **Fear & Greed Index Gauge** — Live data from Alternative.me with color-coded meter
- **Top 10 Trending Coins** — From CoinGecko with market rank, price, 24h change, and sentiment badges
- **Live Price Ticker** — Scrolling bar with top 20 coins and 24h price changes
- **Global Market Metrics** — Total market cap, 24h volume, BTC/ETH dominance, active cryptocurrencies
- **5 Interactive Charts:**
  1. BTC/USD 7-day price line chart
  2. Top 10 market cap doughnut distribution
  3. Top 5 gainers & losers bar chart (24h)
  4. Exchange volume distribution doughnut
  5. Fear & Greed history tracker (per refresh)
- **Market Dominance Bars** — Visual BTC / ETH / Others breakdown
- **localStorage Caching** — 5-minute cache for all API data; works offline after first load
- **Dark Theme UI** — Professional dashboard aesthetic, fully responsive
- **Zero Dependencies** — Only Chart.js loaded from CDN; everything else is vanilla JS

## Installation

No installation required. Just open `index.html` in any modern browser:

```bash
# Option 1: Direct open
open index.html

# Option 2: Local server (recommended for CORS)
python -m http.server 8000
# Then visit http://localhost:8000
```

## Usage

1. Open `index.html` in your browser
2. The dashboard auto-loads all data on open
3. Click **Refresh Data** to manually update
4. Data auto-refreshes every 5 minutes
5. All data is cached in localStorage — close and reopen to see cached values

### Dashboard Sections

| Section | Data Source | Update Frequency |
|---------|------------|------------------|
| Fear & Greed Index | alternative.me API | Every 5 min |
| Trending Coins | CoinGecko `/search/trending` | Every 5 min |
| Price Ticker | CoinGecko `/coins/markets` | Every 5 min |
| Global Metrics | CoinGecko `/global` | Every 5 min |
| Charts | CoinGecko market data | Every 5 min |

## Screenshot

```
+------------------------------------------------------------------+
| CRYPTO SENTIMENT DASHBOARD | Real-time Market Intelligence  [Refresh]
+------------------------------------------------------------------+
| BTC $67,234 +2.1% | ETH $3,456 -0.8% | BNB $598 +1.4% | ...      |
+------------------------------------------------------------------+
|  FEAR & GREED    |  GLOBAL METRICS     |  BTC/USD 7-DAY CHART    |
|      65          |  MCap: $2.3T        |  [line chart]           |
|    GREED         |  Vol: $89B          |                         |
|  [=====|=======] |  BTC Dom: 52%       |                         |
+------------------+---------------------+-------------------------+
|  TOP 10 MCAP     |  GAINERS & LOSERS   |  TRENDING COINS         |
|  [doughnut]      |  [bar chart]        |  [table with sentiment] |
+------------------+---------------------+-------------------------+
|  EXCHANGE VOLUME |  MARKET DOMINANCE   |  F&G HISTORY            |
|  [doughnut]      |  BTC 52% [===]      |  [line chart]           |
|                  |  ETH 18% [=]        |                         |
+------------------+---------------------+-------------------------+
```

## Architecture

- **`index.html`** — Semantic HTML5 structure with grid layout
- **`styles.css`** — Dark theme CSS with custom properties, responsive grid, animations
- **`dashboard.js`** — All JavaScript logic:
  - API fetching with error handling
  - localStorage cache layer (5-min TTL)
  - Chart.js rendering (5 canvas instances)
  - DOM manipulation for tables, metrics, and ticker
  - Toast notification system

## APIs Used

- [CoinGecko Public API](https://www.coingecko.com/en/api) — Free, no key required
- [Alternative.me Fear & Greed Index](https://alternative.me/crypto/fear-and-greed-index/) — Free, no key required
- [Chart.js](https://www.chartjs.org/) — CDN-loaded charting library

## License

MIT

---

Created by **Israel Romero Apo** | [israelromero.xyz](https://israelromero.xyz)
