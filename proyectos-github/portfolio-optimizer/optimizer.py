#!/usr/bin/env python3
"""
Portfolio Optimizer - Markowitz mean-variance optimization with Monte Carlo simulation.
Computes the efficient frontier, finds the maximum Sharpe ratio and minimum variance
portfolios, and generates visualizations of optimal allocations.
"""

import argparse
import sys
import warnings
from datetime import datetime, timedelta

import matplotlib
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

matplotlib.use("Agg")
warnings.filterwarnings("ignore", category=FutureWarning)

RISK_FREE_RATE = 0.02
TRADING_DAYS = 252
NUM_PORTFOLIOS = 10_000


def fetch_data(tickers: list[str], period: str = "1y") -> pd.DataFrame:
    """Download adjusted close prices from Yahoo Finance using yfinance."""
    try:
        import yfinance as yf
    except ImportError:
        print("[!] yfinance not installed. Run: pip install yfinance")
        print("[*] Using synthetic data instead for demonstration.")
        return _synthetic_data(tickers)

    data = yf.download(tickers, period=period, progress=False, auto_adjust=True)
    if data.empty:
        print("[!] No data returned from Yahoo Finance. Using synthetic data.")
        return _synthetic_data(tickers)

    if "Close" in data.columns:
        close = data["Close"]
    elif isinstance(data.columns, pd.MultiIndex):
        close = data["Close"]
    else:
        close = data

    if isinstance(close, pd.DataFrame):
        close = close[tickers] if set(tickers).issubset(close.columns) else close
    return close.dropna()


def _synthetic_data(tickers: list[str]) -> pd.DataFrame:
    """Generate synthetic price data for demo purposes."""
    np.random.seed(42)
    n = 252
    dates = pd.date_range(end=datetime.now(), periods=n, freq="B")
    data = {}
    for i, t in enumerate(tickers):
        drift = 0.0003 + np.random.uniform(-0.0002, 0.0006)
        vol = 0.012 + np.random.uniform(0, 0.015)
        returns = np.random.normal(drift, vol, n)
        data[t] = 100 * np.exp(np.cumsum(returns))
    return pd.DataFrame(data, index=dates)


def compute_metrics(prices: pd.DataFrame) -> tuple[pd.Series, pd.DataFrame]:
    """Compute annualized expected returns and covariance matrix."""
    daily_returns = prices.pct_change().dropna()
    expected_returns = daily_returns.mean() * TRADING_DAYS
    cov_matrix = daily_returns.cov() * TRADING_DAYS
    return expected_returns, cov_matrix


def simulate_portfolios(
    mean_returns: pd.Series,
    cov_matrix: pd.DataFrame,
    num_portfolios: int = NUM_PORTFOLIOS,
) -> pd.DataFrame:
    """Monte Carlo simulation of random portfolio weight combinations."""
    n_assets = len(mean_returns)
    results = np.zeros((4, num_portfolios))
    weights_record = np.zeros((num_portfolios, n_assets))

    for i in range(num_portfolios):
        w = np.random.random(n_assets)
        w /= w.sum()

        portfolio_return = np.dot(w, mean_returns.values)
        portfolio_vol = np.sqrt(np.dot(w.T, np.dot(cov_matrix.values, w)))
        sharpe = (portfolio_return - RISK_FREE_RATE) / portfolio_vol if portfolio_vol > 0 else 0

        results[0, i] = portfolio_return
        results[1, i] = portfolio_vol
        results[2, i] = sharpe
        weights_record[i, :] = w

    return pd.DataFrame(
        results.T, columns=["Return", "Volatility", "Sharpe", "WeightIdx"]
    ), weights_record


def find_optimal_portfolio(
    mean_returns: pd.Series, cov_matrix: pd.DataFrame, objective: str = "sharpe"
) -> dict:
    """Use scipy optimizer to find the optimal portfolio (max Sharpe or min variance)."""
    try:
        from scipy.optimize import minimize
    except ImportError:
        print("[!] scipy not installed. Run: pip install scipy")
        return _equal_weights(mean_returns)

    n = len(mean_returns)
    bounds = tuple((0, 1) for _ in range(n))
    constraints = ({"type": "eq", "fun": lambda w: np.sum(w) - 1},)
    x0 = np.ones(n) / n

    if objective == "sharpe":
        def neg_sharpe(w):
            pr = np.dot(w, mean_returns.values)
            pv = np.sqrt(np.dot(w.T, np.dot(cov_matrix.values, w)))
            return -(pr - RISK_FREE_RATE) / pv if pv > 0 else 1e9
        result = minimize(neg_sharpe, x0, method="SLSQP", bounds=bounds, constraints=constraints)
    else:
        def portfolio_vol(w):
            return np.sqrt(np.dot(w.T, np.dot(cov_matrix.values, w)))
        result = minimize(portfolio_vol, x0, method="SLSQP", bounds=bounds, constraints=constraints)

    weights = result.x
    pr = np.dot(weights, mean_returns.values)
    pv = np.sqrt(np.dot(weights.T, np.dot(cov_matrix.values, weights)))
    sharpe = (pr - RISK_FREE_RATE) / pv if pv > 0 else 0

    return {
        "weights": {t: weights[i] for i, t in enumerate(mean_returns.index)},
        "return": pr,
        "volatility": pv,
        "sharpe": sharpe,
    }


def _equal_weights(mean_returns: pd.Series) -> dict:
    n = len(mean_returns)
    w = np.ones(n) / n
    return {"weights": {t: 1 / n for t in mean_returns.index}, "return": 0, "volatility": 0, "sharpe": 0}


def plot_efficient_frontier(
    mean_returns: pd.Series,
    cov_matrix: pd.DataFrame,
    optimal_sharpe: dict | None = None,
    optimal_minvar: dict | None = None,
    filepath: str = "efficient_frontier.png",
):
    results_df, _ = simulate_portfolios(mean_returns, cov_matrix)

    plt.figure(figsize=(10, 7))
    scatter = plt.scatter(
        results_df["Volatility"] * 100,
        results_df["Return"] * 100,
        c=results_df["Sharpe"],
        cmap="viridis",
        alpha=0.6,
        s=15,
    )
    cbar = plt.colorbar(scatter)
    cbar.set_label("Sharpe Ratio", fontsize=11)

    if optimal_sharpe and optimal_sharpe["return"] > 0:
        plt.scatter(
            optimal_sharpe["volatility"] * 100,
            optimal_sharpe["return"] * 100,
            color="red",
            marker="*",
            s=300,
            label="Max Sharpe Ratio",
            zorder=5,
        )
    if optimal_minvar and optimal_minvar["volatility"] > 0:
        plt.scatter(
            optimal_minvar["volatility"] * 100,
            optimal_minvar["return"] * 100,
            color="blue",
            marker="*",
            s=300,
            label="Min Variance",
            zorder=5,
        )

    plt.xlabel("Expected Volatility (%)", fontsize=12)
    plt.ylabel("Expected Return (%)", fontsize=12)
    plt.title("Markowitz Efficient Frontier", fontsize=14)
    plt.legend(fontsize=10)
    plt.grid(alpha=0.3)
    plt.tight_layout()
    plt.savefig(filepath, dpi=150, bbox_inches="tight")
    plt.close()
    print(f"[+] Efficient frontier saved to {filepath}")


def plot_pie_chart(weights: dict, title: str = "Optimal Portfolio Allocation", filepath: str = "portfolio_pie.png"):
    labels = [k for k, v in weights.items() if v > 0.01]
    sizes = [v * 100 for v in weights.values() if v > 0.01]

    if sum(v for v in weights.values() if v <= 0.01) > 0:
        labels.append("Others")
        sizes.append(sum(v * 100 for v in weights.values() if v <= 0.01))

    colors = plt.cm.tab20(np.linspace(0, 1, len(labels)))

    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 6))

    wedges, texts, autotexts = ax1.pie(sizes, labels=None, autopct="%1.1f%%",
                                        colors=colors, startangle=140, pctdistance=0.85)
    for t in autotexts:
        t.set_fontsize(9)
    ax1.set_title(title, fontsize=13)

    bars_x = np.arange(len(labels))
    ax2.barh(bars_x, sizes, color=colors, edgecolor="white")
    ax2.set_yticks(bars_x)
    ax2.set_yticklabels(labels)
    ax2.set_xlabel("Allocation (%)")
    ax2.invert_yaxis()
    ax2.set_title("Weight Distribution", fontsize=13)
    ax2.grid(axis="x", alpha=0.3)

    plt.tight_layout()
    plt.savefig(filepath, dpi=150, bbox_inches="tight")
    plt.close()
    print(f"[+] Portfolio pie chart saved to {filepath}")


def run_optimization(
    tickers: list[str],
    period: str = "1y",
    risk_free: float = RISK_FREE_RATE,
) -> dict:
    global RISK_FREE_RATE
    RISK_FREE_RATE = risk_free

    print(f"[*] Fetching data for: {', '.join(tickers)}")
    prices = fetch_data(tickers, period)
    print(f"[*] Data shape: {prices.shape} (rows x columns)")

    mean_returns, cov_matrix = compute_metrics(prices)

    print(f"\n{'='*55}")
    print(f"  EXPECTED ANNUAL METRICS (Risk-free rate: {risk_free*100:.1f}%)")
    print(f"{'='*55}")
    for t in tickers:
        vol = np.sqrt(cov_matrix.loc[t, t])
        print(f"  {t:>6}:  Return={mean_returns[t]*100:>7.2f}%  Vol={vol*100:>6.2f}%  "
              f"Sharpe={(mean_returns[t]-risk_free)/vol:>6.2f}")

    optimal_sharpe = find_optimal_portfolio(mean_returns, cov_matrix, "sharpe")
    optimal_minvar = find_optimal_portfolio(mean_returns, cov_matrix, "variance")

    print(f"\n{'='*55}")
    print(f"  MAX SHARPE RATIO PORTFOLIO")
    print(f"{'='*55}")
    print(f"  Expected Return:  {optimal_sharpe['return']*100:>8.2f}%")
    print(f"  Volatility:       {optimal_sharpe['volatility']*100:>8.2f}%")
    print(f"  Sharpe Ratio:     {optimal_sharpe['sharpe']:>8.2f}")
    print(f"  Weights:")
    for t, w in sorted(optimal_sharpe["weights"].items(), key=lambda x: -x[1]):
        if w > 0.001:
            print(f"    {t:>6}: {w*100:>7.2f}%")

    print(f"\n{'='*55}")
    print(f"  MINIMUM VARIANCE PORTFOLIO")
    print(f"{'='*55}")
    print(f"  Expected Return:  {optimal_minvar['return']*100:>8.2f}%")
    print(f"  Volatility:       {optimal_minvar['volatility']*100:>8.2f}%")
    print(f"  Sharpe Ratio:     {optimal_minvar['sharpe']:>8.2f}")
    print(f"  Weights:")
    for t, w in sorted(optimal_minvar["weights"].items(), key=lambda x: -x[1]):
        if w > 0.001:
            print(f"    {t:>6}: {w*100:>7.2f}%")

    plot_efficient_frontier(mean_returns, cov_matrix, optimal_sharpe, optimal_minvar)
    plot_pie_chart(optimal_sharpe["weights"], "Max Sharpe Ratio Portfolio", "portfolio_sharpe.png")
    plot_pie_chart(optimal_minvar["weights"], "Minimum Variance Portfolio", "portfolio_minvar.png")

    return optimal_sharpe


def main():
    parser = argparse.ArgumentParser(
        description="Portfolio Optimizer - Markowitz mean-variance optimization with Monte Carlo simulation."
    )
    parser.add_argument("--tickers", nargs="+", default=["AAPL", "MSFT", "GOOGL", "AMZN", "TSLA"],
                        help="List of ticker symbols (default: AAPL MSFT GOOGL AMZN TSLA)")
    parser.add_argument("--period", default="1y", help="Data period: 1mo, 3mo, 6mo, 1y, 2y, 5y, max (default: 1y)")
    parser.add_argument("--risk-free", type=float, default=RISK_FREE_RATE,
                        help=f"Risk-free rate as decimal (default: {RISK_FREE_RATE})")

    args = parser.parse_args()
    run_optimization(args.tickers, args.period, args.risk_free)


if __name__ == "__main__":
    main()
