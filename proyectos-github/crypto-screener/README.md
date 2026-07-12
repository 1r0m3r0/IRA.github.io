# Crypto Screener

A Python CLI tool that scans the CoinGecko public API to identify cryptocurrency trading opportunities. Computes simplified RSI, volume/market-cap ratios, and opportunity scores with color-coded terminal output and CSV export.

## Features

- Fetches top N coins by market cap from CoinGecko (no API key required)
- Computes **simplified 14-period RSI** from 7-day sparkline price data
- Calculates **volume-to-market-cap ratio** to gauge trading activity
- **Opportunity scoring** (0-100): considers RSI oversold/overbought, vol/mcap ratio, and 24h price change
- **Color-coded table** output (green = opportunity, yellow = moderate, red = weak)
- **Flexible filtering**: min volume, min market cap, max RSI, price change range
- **CSV export** for further analysis
- Works entirely from the command line

## Installation

```bash
cd crypto-screener
pip install -r requirements.txt
```

## Usage

```bash
# Basic: scan top 50 coins
python screener.py

# Scan top 100, filter for oversold only (RSI < 50)
python screener.py --top 100 --rsi-max 50

# Filter by minimum volume and market cap, export to CSV
python screener.py --min-volume 50000000 --min-mcap 1000000000 --export results.csv

# Look for coins dipping > 5% today
python screener.py --max-change -5

# All flags combined
python screener.py --top 200 --min-volume 10000000 --min-mcap 500000000 --rsi-max 45 --export opportunities.csv
```

### Command-line Arguments

| Flag | Description | Default |
|------|-------------|---------|
| `--top N` | Number of top coins to fetch | 50 |
| `--min-volume X` | Minimum 24h volume (USD) | None |
| `--min-mcap X` | Minimum market cap (USD) | None |
| `--rsi-max X` | Maximum RSI threshold | None |
| `--min-change X` | Minimum 24h price change % | None |
| `--max-change X` | Maximum 24h price change % | None |
| `--export FILE` | Export results to CSV | None |

## Example Output

```
============================================================
  CRYPTO SCREENER v1.0
  2025-07-11 14:30 UTC
============================================================
[*] Fetching top 50 coins from CoinGecko...

+--------+---------------------+-------+------------+----------+----------+------------+---------+
|   Rank | Name                | Sym   | Price      | 24h Chg  | RSI(14)  | Vol/MCap   | Score   |
+========+=====================+=======+============+==========+==========+============+=========+
|      7 | XRP                 | XRP   | $0.5234    | +2.34%   | 48.3     | 5.2%       | 75/100  |
|     14 | Chainlink           | LINK  | $14.32     | -3.21%   | 42.1     | 8.7%       | 72/100  |
|     21 | Cosmos              | ATOM  | $8.91      | -1.20%   | 44.8     | 6.1%       | 68/100  |
|      9 | Cardano             | ADA   | $0.3801    | +1.80%   | 51.2     | 3.4%       | 63/100  |
|     33 | Algorand            | ALGO  | $0.1453    | -4.50%   | 38.9     | 4.9%       | 65/100  |
+--------+---------------------+-------+------------+----------+----------+------------+---------+

  GREEN  = Strong opportunity (score >= 65)
  YELLOW = Moderate opportunity (score 45-64)
  RED    = Weak / overbought (score < 45)

[*] Top 5 opportunities:
  1. XRP (XRP) - Score: 75/100, RSI: 48.3, 24h: +2.34%
  2. Chainlink (LINK) - Score: 72/100, RSI: 42.1, 24h: -3.21%
  3. Cosmos (ATOM) - Score: 68/100, RSI: 44.8, 24h: -1.20%
  4. Algorand (ALGO) - Score: 65/100, RSI: 38.9, 24h: -4.50%
  5. Cardano (ADA) - Score: 63/100, RSI: 51.2, 24h: +1.80%
```

## How the Simplified RSI Works

Since the free CoinGecko API doesn't provide historical OHLCV per coin in a single call, the screener uses the **7-day sparkline** (a ~168-point price array included in the `/coins/markets` endpoint) to compute a simplified 14-interval RSI. This provides a reasonable approximation of momentum for screening purposes without requiring additional API calls.

## Dependencies

- **requests** — HTTP client for CoinGecko API
- **tabulate** — Pretty-print tables in the terminal
- **colorama** — Cross-platform colored terminal output

## License

MIT

---

Created by **Israel Romero Apo** | [israelromero.xyz](https://israelromero.xyz)
