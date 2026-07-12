# Backtest Engine

A modular Python backtesting framework for evaluating trading strategies. Supports customizable entry/exit signals, multiple position sizing methods (fixed fractional, Kelly criterion), commission and slippage modeling, comprehensive performance metrics, and equity curve visualization.

## Features

- **OHLCV Data Loading** — Accepts CSV files or pandas DataFrames
- **Modular Strategy System** — Plug in any strategy function that returns buy/sell/hold signals
- **Performance Metrics:**
  - Total Return & Annualized Return
  - Annualized Volatility
  - Sharpe Ratio
  - Maximum Drawdown
  - Win Rate & Profit Factor
  - Trade-level P&L log
- **Position Sizing:**
  - Fixed fractional (% of capital per trade)
  - Kelly Criterion (dynamic, based on trade history)
- **Realistic Modeling:**
  - Commission (as % of trade value)
  - Slippage (as % of fill price)
- **Equity Curve Visualization** — Saves as PNG with buy/sell markers
- **4 Built-in Strategies:** SMA crossover, RSI mean reversion, MACD crossover, Bollinger Bands reversal
- **Synthetic Data Generator** — For quick testing without external data

## Installation

```bash
cd backtest-engine
pip install -r requirements.txt
```

## Usage

### Quick Start (with synthetic data)

```bash
python engine.py
```

This runs all 4 built-in strategies against randomly generated OHLCV data and saves equity curve charts:

```
[*] Generating sample OHLCV data...

=======================================================
  Strategy 1: SMA Crossover (fast=10, slow=30)
=======================================================
=======================================================
  BACKTEST RESULTS
=======================================================
  Total Return:               12.45%
  Annualized Return:           6.28%
  Annualized Vol:             18.32%
  Sharpe Ratio:                0.23
  Max Drawdown:              -15.67%
  Win Rate:                   42.30%
  Profit Factor:               1.34
  Total Trades:                 26
  Winning Trades:               11
  Losing Trades:                15
=======================================================
[+] Equity curve saved to equity_curve_sma.png
...
```

### Using Your Own CSV Data

```python
from engine import BacktestEngine, load_csv
from strategies import sma_crossover

# Load your data (must have: date, open, high, low, close, volume)
df = load_csv("my_data.csv")

# Create engine with 1% commission and 0.05% slippage
engine = BacktestEngine(
    df,
    strategy_fn=sma_crossover,
    initial_capital=50_000,
    commission=0.001,
    slippage=0.0005,
    position_size="fixed",
    position_size_pct=0.25,
)

# Run with strategy parameters
result = engine.run(fast=10, slow=30)
print(result.summary())
engine.plot_equity_curve("my_strategy.png")
```

### Writing a Custom Strategy

```python
import pandas as pd

def my_strategy(df: pd.DataFrame, threshold: float = 0.02) -> pd.Series:
    """
    Must return a pd.Series with values: 1 = buy, -1 = sell, 0 = hold.
    Index must match df.index.
    """
    close = df["close"]
    signals = pd.Series(0, index=df.index, dtype=int)

    # Example: buy when price drops > threshold, sell when up > threshold
    returns = close.pct_change()
    signals[returns < -threshold] = 1
    signals[returns > threshold] = -1

    return signals
```

### Built-in Strategies

| Strategy | Parameters | Logic |
|----------|-----------|-------|
| `sma_crossover` | `fast=10, slow=30` | Buy when fast SMA crosses above slow; sell on cross below |
| `rsi_mean_reversion` | `period=14, oversold=30, overbought=70` | Buy when RSI recovers from oversold; sell when drops from overbought |
| `macd_crossover` | `fast=12, slow=26, signal_period=9` | Buy when MACD line crosses above signal; sell on cross below |
| `bollinger_bands_reversal` | `period=20, std_dev=2.0` | Buy at lower band touch; sell at upper band touch |

### CSV Data Format

Your CSV must include these columns (lowercase):

```
date,open,high,low,close,volume
2024-01-01,100.0,102.5,99.0,101.2,1500000
2024-01-02,101.2,103.8,100.5,102.7,1800000
...
```

## Performance Metrics Explained

- **Sharpe Ratio:** Risk-adjusted return (excess return / volatility). > 1 is good.
- **Max Drawdown:** Largest peak-to-trough decline in equity.
- **Win Rate:** Percentage of trades that ended profitably.
- **Profit Factor:** Gross profit / gross loss. > 1.5 is strong.

## Dependencies

- **pandas** — Data manipulation
- **numpy** — Numerical computations
- **matplotlib** — Chart generation

## License

MIT

---

Created by **Israel Romero Apo** | [israelromero.xyz](https://israelromero.xyz)
