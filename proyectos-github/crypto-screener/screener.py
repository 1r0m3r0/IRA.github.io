#!/usr/bin/env python3
"""
Crypto Screener - CLI tool that scans CoinGecko API for crypto opportunities.
Computes simplified RSI, volume/market-cap ratios, and displays a color-coded
opportunity table with filtering and CSV export.
"""

import argparse
import csv
import os
import sys
from datetime import datetime, timezone

import requests
from colorama import Fore, Style, init
from tabulate import tabulate

init(autoreset=True)

COINGECKO_API = "https://api.coingecko.com/api/v3"
DEFAULT_TOP = 50
DEFAULT_RSI_PERIOD = 14


def fetch_coins(top_n: int = DEFAULT_TOP) -> list[dict]:
    """Fetch top N coins by market cap from CoinGecko with 7-day sparkline data."""
    url = (
        f"{COINGECKO_API}/coins/markets"
        f"?vs_currency=usd&order=market_cap_desc&per_page={top_n}"
        f"&page=1&sparkline=true&price_change_percentage=24h,7d"
    )
    resp = requests.get(url, timeout=30)
    resp.raise_for_status()
    return resp.json()


def simplify_rsi(prices: list[float], period: int = DEFAULT_RSI_PERIOD) -> float | None:
    """Compute a simplified RSI from a price series (e.g. 7-day sparkline)."""
    if len(prices) < period + 1:
        return None
    deltas = [prices[i] - prices[i - 1] for i in range(1, len(prices))]
    gains = sum(max(d, 0) for d in deltas[-period:])
    losses = sum(abs(min(d, 0)) for d in deltas[-period:])
    if losses == 0:
        return 100.0
    rs = gains / losses
    return 100.0 - (100.0 / (1.0 + rs))


def vol_to_mcap_ratio(volume: float | None, mcap: float | None) -> float | None:
    """Volume / Market Cap ratio. High values indicate active trading."""
    if not mcap or mcap == 0:
        return None
    return (volume / mcap) if volume else None


def score_coin(rsi: float | None, vol_ratio: float | None, change24: float | None) -> int:
    """
    Compute a simple opportunity score (0-100).
    - Undervalued RSI (30-50) gets points
    - High vol/mcap ratio gets points
    - Slightly negative or positive change gets points
    """
    score = 50
    if rsi is not None:
        if 30 <= rsi <= 40:
            score += 20  # oversold
        elif 40 < rsi <= 50:
            score += 10
        elif rsi > 70:
            score -= 20  # overbought
    if vol_ratio is not None:
        if vol_ratio > 0.3:
            score += 15
        elif vol_ratio > 0.1:
            score += 8
    if change24 is not None:
        if -10 <= change24 <= -2:
            score += 10  # dip buying
        elif 0 <= change24 <= 5:
            score += 5
    return max(0, min(100, score))


def color_for_score(score: int) -> str:
    if score >= 65:
        return Fore.GREEN
    elif score >= 45:
        return Fore.YELLOW
    else:
        return Fore.RED


def run_screener(
    top: int,
    min_volume: float | None,
    min_mcap: float | None,
    rsi_max: float | None,
    min_change: float | None,
    max_change: float | None,
):
    print(f"{Fore.CYAN}[*] Fetching top {top} coins from CoinGecko...{Style.RESET_ALL}")
    try:
        coins = fetch_coins(top)
    except requests.RequestException as e:
        print(f"{Fore.RED}[!] API error: {e}{Style.RESET_ALL}")
        sys.exit(1)

    results = []
    for c in coins:
        sparkline = c.get("sparkline_in_7d", {}).get("price", [])
        rsi = simplify_rsi(sparkline) if sparkline else None

        vol = c.get("total_volume")
        mcap = c.get("market_cap")
        ratio = vol_to_mcap_ratio(vol, mcap)
        change24 = c.get("price_change_percentage_24h")

        if min_volume is not None and (vol is None or vol < min_volume):
            continue
        if min_mcap is not None and (mcap is None or mcap < min_mcap):
            continue
        if rsi_max is not None and (rsi is not None and rsi > rsi_max):
            continue
        if min_change is not None and (change24 is not None and change24 < min_change):
            continue
        if max_change is not None and (change24 is not None and change24 > max_change):
            continue

        score = score_coin(rsi, ratio, change24)
        results.append({
            "rank": c.get("market_cap_rank", 0),
            "name": c.get("name", "?"),
            "symbol": c.get("symbol", "?").upper(),
            "price": c.get("current_price"),
            "change_24h": change24,
            "change_7d": c.get("price_change_percentage_7d_in_currency"),
            "volume_24h": vol,
            "market_cap": mcap,
            "rsi_14": round(rsi, 2) if rsi is not None else None,
            "vol_mcap_ratio": round(ratio * 100, 2) if ratio is not None else None,
            "score": score,
        })

    results.sort(key=lambda x: x["score"], reverse=True)

    return results


def format_table(results: list[dict]) -> str:
    rows = []
    for r in results:
        color = color_for_score(r["score"])
        change_str = f"{r['change_24h']:+.2f}%" if r["change_24h"] is not None else "N/A"
        rsi_str = f"{r['rsi_14']:.1f}" if r['rsi_14'] is not None else "N/A"
        ratio_str = f"{r['vol_mcap_ratio']:.1f}%" if r['vol_mcap_ratio'] is not None else "N/A"
        price_str = f"${r['price']:,.4f}" if r['price'] and r['price'] >= 0.01 else f"${r['price']:,.8f}" if r['price'] else "N/A"
        mcap_str = f"${r['market_cap']:,.0f}" if r['market_cap'] else "N/A"

        rows.append([
            color + str(r["rank"]) + Style.RESET_ALL,
            color + r["name"] + Style.RESET_ALL,
            color + r["symbol"] + Style.RESET_ALL,
            price_str,
            color + change_str + Style.RESET_ALL,
            color + rsi_str + Style.RESET_ALL,
            ratio_str,
            color + f"{r['score']}/100" + Style.RESET_ALL,
        ])

    headers = ["Rank", "Name", "Sym", "Price", "24h Chg", "RSI(14)", "Vol/MCap", "Score"]
    return tabulate(rows, headers=headers, tablefmt="grid")


def legend() -> str:
    return (
        f"\n{Fore.GREEN}  GREEN  = Strong opportunity (score >= 65){Style.RESET_ALL}\n"
        f"{Fore.YELLOW}  YELLOW = Moderate opportunity (score 45-64){Style.RESET_ALL}\n"
        f"{Fore.RED}  RED    = Weak / overbought (score < 45){Style.RESET_ALL}\n"
    )


def export_csv(results: list[dict], filepath: str):
    with open(filepath, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=results[0].keys())
        writer.writeheader()
        writer.writerows(results)
    print(f"{Fore.GREEN}[+] Exported {len(results)} rows to {filepath}{Style.RESET_ALL}")


def main():
    parser = argparse.ArgumentParser(
        description="Crypto Screener - Scan CoinGecko top coins for trading opportunities."
    )
    parser.add_argument("--top", type=int, default=DEFAULT_TOP, help="Number of top coins to fetch (default: 50)")
    parser.add_argument("--min-volume", type=float, default=None, help="Minimum 24h volume (USD)")
    parser.add_argument("--min-mcap", type=float, default=None, help="Minimum market cap (USD)")
    parser.add_argument("--rsi-max", type=float, default=None, help="Maximum RSI threshold (e.g. 50 for oversold only)")
    parser.add_argument("--min-change", type=float, default=None, help="Minimum 24h price change %%")
    parser.add_argument("--max-change", type=float, default=None, help="Maximum 24h price change %%")
    parser.add_argument("--export", type=str, default=None, metavar="FILE", help="Export results to CSV file")

    args = parser.parse_args()

    print(f"{Fore.CYAN}{'='*60}")
    print(f"  CRYPTO SCREENER v1.0")
    print(f"  {datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M UTC')}")
    print(f"{'='*60}{Style.RESET_ALL}")

    results = run_screener(
        top=args.top,
        min_volume=args.min_volume,
        min_mcap=args.min_mcap,
        rsi_max=args.rsi_max,
        min_change=args.min_change,
        max_change=args.max_change,
    )

    if not results:
        print(f"{Fore.YELLOW}[!] No coins matched your filters.{Style.RESET_ALL}")
        return

    print(format_table(results))
    print(legend())

    top5 = results[:5]
    print(f"{Fore.CYAN}[*] Top 5 opportunities:{Style.RESET_ALL}")
    for i, r in enumerate(top5, 1):
        color = color_for_score(r["score"])
        print(color + f"  {i}. {r['name']} ({r['symbol']}) - Score: {r['score']}/100, RSI: {r['rsi_14']}, 24h: {r['change_24h']:+.2f}%" + Style.RESET_ALL)

    if args.export:
        export_csv(results, args.export)


if __name__ == "__main__":
    main()
