# Portfolio Optimizer

A Python implementation of Markowitz mean-variance portfolio optimization with Monte Carlo simulation. Downloads real market data via Yahoo Finance (or uses synthetic data for offline demos), computes the efficient frontier, and finds optimal portfolio weights for maximum Sharpe ratio and minimum variance.

## Features

- **Data Source** — Real market data via `yfinance` or synthetic data for offline testing
- **Expected Returns & Covariance Matrix** — Annualized from daily price history
- **Monte Carlo Simulation** — 10,000+ random portfolio weight combinations
- **Efficient Frontier Plot** — Color-coded by Sharpe ratio, with optimal portfolio markers
- **Optimal Portfolios:**
  - **Max Sharpe Ratio** — Highest risk-adjusted return
  - **Minimum Variance** — Lowest volatility allocation
- **Weight Distribution Charts** — Pie chart + horizontal bar chart per portfolio
- **Configurable Risk-Free Rate** — Adjust for current treasury yields
- **Full CLI Interface** — Specify tickers, period, and risk-free rate

## Installation

```bash
cd portfolio-optimizer
pip install -r requirements.txt
```

## Usage

### Command Line

```bash
# Default: AAPL, MSFT, GOOGL, AMZN, TSLA (1 year)
python optimizer.py

# Custom tickers with 5-year history
python optimizer.py --tickers BTC-USD ETH-USD SOL-USD ADA-USD --period 5y

# Portfolio of ETFs with 3% risk-free rate
python optimizer.py --tickers SPY QQQ IWM GLD TLT --period 2y --risk-free 0.03

# Full list of periods: 1mo, 3mo, 6mo, 1y, 2y, 5y, max
python optimizer.py --tickers NVDA AMD INTC --period 6mo
```

### Python API

```python
from optimizer import run_optimization

result = run_optimization(
    tickers=["AAPL", "MSFT", "GOOGL", "AMZN", "NVDA"],
    period="1y",
    risk_free=0.02,
)

print(result["weights"])
# {'AAPL': 0.18, 'MSFT': 0.22, 'GOOGL': 0.15, 'AMZN': 0.20, 'NVDA': 0.25}
```

## Example Output

```
[*] Fetching data for: AAPL, MSFT, GOOGL, AMZN, TSLA
[*] Data shape: 252 (rows x columns)

=======================================================
  EXPECTED ANNUAL METRICS (Risk-free rate: 2.0%)
=======================================================
    AAPL:  Return=  15.23%  Vol= 22.10%  Sharpe=  0.60
    MSFT:  Return=  18.45%  Vol= 20.80%  Sharpe=  0.79
   GOOGL:  Return=  12.80%  Vol= 24.30%  Sharpe=  0.44
    AMZN:  Return=  14.10%  Vol= 26.50%  Sharpe=  0.46
    TSLA:  Return=  22.30%  Vol= 45.20%  Sharpe=  0.45

=======================================================
  MAX SHARPE RATIO PORTFOLIO
=======================================================
  Expected Return:     18.45%
  Volatility:          18.92%
  Sharpe Ratio:         0.87
  Weights:
    MSFT:   35.20%
    AAPL:   28.10%
    NVDA:   18.50%
    GOOGL:  12.30%
    AMZN:    5.90%

=======================================================
  MINIMUM VARIANCE PORTFOLIO
=======================================================
  Expected Return:     14.72%
  Volatility:          16.30%
  Sharpe Ratio:         0.78
  Weights:
    MSFT:   32.40%
    AAPL:   30.20%
    GOOGL:  20.10%
    AMZN:   17.30%
```

**Generated Charts:**
- `efficient_frontier.png` — Monte Carlo simulation with optimal portfolio markers
- `portfolio_sharpe.png` — Max Sharpe ratio allocation pie + bar charts
- `portfolio_minvar.png` — Minimum variance allocation pie + bar charts

## How It Works

1. Download adjusted close prices for each ticker (Yahoo Finance or synthetic)
2. Compute daily returns → annualized expected returns and covariance matrix
3. Run Monte Carlo simulation (10,000 random weight vectors)
4. Use `scipy.optimize` to find the exact max-Sharpe and min-variance weights
5. Plot efficient frontier with color-coded Sharpe ratios
6. Generate allocation visualizations

## Dependencies

- **numpy** — Numerical computation
- **scipy** — Constrained optimization (SLSQP)
- **pandas** — Data handling
- **matplotlib** — Chart generation
- **yfinance** — Market data download (optional; falls back to synthetic data)

## License

MIT

---

Created by **Israel Romero Apo** | [israelromero.xyz](https://israelromero.xyz)
