#!/usr/bin/env python3
"""
Backtest Engine - A modular Python backtesting framework for trading strategies.
Supports custom entry/exit signals, position sizing, commission, slippage, and
performance metrics including Sharpe ratio, max drawdown, win rate, profit factor,
and equity curve visualization.
"""

import warnings
from dataclasses import dataclass, field
from typing import Callable

import matplotlib
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

matplotlib.use("Agg")
warnings.filterwarnings("ignore", category=FutureWarning)


@dataclass
class BacktestResult:
    total_return: float = 0.0
    annualized_return: float = 0.0
    annualized_volatility: float = 0.0
    sharpe_ratio: float = 0.0
    max_drawdown: float = 0.0
    win_rate: float = 0.0
    profit_factor: float = 0.0
    total_trades: int = 0
    winning_trades: int = 0
    losing_trades: int = 0
    equity_curve: pd.Series = field(default_factory=pd.Series)
    trade_log: list[dict] = field(default_factory=list)

    def summary(self) -> str:
        lines = [
            "=" * 55,
            "  BACKTEST RESULTS",
            "=" * 55,
            f"  Total Return:        {self.total_return * 100:>10.2f}%",
            f"  Annualized Return:   {self.annualized_return * 100:>10.2f}%",
            f"  Annualized Vol:      {self.annualized_volatility * 100:>10.2f}%",
            f"  Sharpe Ratio:        {self.sharpe_ratio:>10.2f}",
            f"  Max Drawdown:        {self.max_drawdown * 100:>10.2f}%",
            f"  Win Rate:            {self.win_rate * 100:>10.2f}%",
            f"  Profit Factor:       {self.profit_factor:>10.2f}",
            f"  Total Trades:        {self.total_trades:>10d}",
            f"  Winning Trades:      {self.winning_trades:>10d}",
            f"  Losing Trades:       {self.losing_trades:>10d}",
            "=" * 55,
        ]
        return "\n".join(lines)


class BacktestEngine:
    """
    Event-driven backtesting engine for OHLCV data.

    Parameters
    ----------
    data : pd.DataFrame
        Must contain columns: open, high, low, close, volume (lowercase).
    strategy_fn : Callable
        Function(df, **kwargs) -> pd.Series of signals (-1, 0, 1).
    initial_capital : float
    commission : float
        Percentage commission per trade (e.g. 0.001 = 0.1%).
    slippage : float
        Percentage slippage per trade (e.g. 0.0005 = 0.05%).
    position_size : str | float
        "fixed" for fixed fractional (uses position_size_pct) or "kelly".
    position_size_pct : float
        Fraction of capital to risk per trade (0 < pct <= 1).
    """

    def __init__(
        self,
        data: pd.DataFrame,
        strategy_fn: Callable,
        initial_capital: float = 10_000.0,
        commission: float = 0.001,
        slippage: float = 0.0005,
        position_size: str = "fixed",
        position_size_pct: float = 0.2,
    ):
        self._validate_data(data)
        self.data = data.copy()
        self.strategy_fn = strategy_fn
        self.initial_capital = initial_capital
        self.commission = commission
        self.slippage = slippage
        self.position_size = position_size
        self.position_size_pct = position_size_pct

        self.signals: pd.Series | None = None

    @staticmethod
    def _validate_data(df: pd.DataFrame):
        required = {"open", "high", "low", "close", "volume"}
        missing = required - set(df.columns)
        if missing:
            raise ValueError(f"DataFrame missing columns: {missing}")

    def generate_signals(self, **kwargs) -> pd.Series:
        self.signals = self.strategy_fn(self.data, **kwargs)
        return self.signals

    def run(self, **strategy_kwargs) -> BacktestResult:
        if self.signals is None:
            self.generate_signals(**strategy_kwargs)

        capital = self.initial_capital
        position = 0
        entry_price = 0.0
        equity = []
        trades = []
        cash = capital

        prices = self.data["close"].values
        signals = self.signals.values
        dates = self.data.index if hasattr(self.data.index, "__iter__") else range(len(self.data))

        for i in range(len(self.data)):
            price = float(prices[i])
            sig = int(signals[i])
            event = {"type": "hold", "price": price, "date": str(dates[i])}

            if sig == 1 and position == 0:
                fill_price = price * (1 + self.slippage)
                cost = fill_price * (1 + self.commission)

                if self.position_size == "kelly" and len(trades) >= 5:
                    wins = sum(1 for t in trades if t["pnl"] > 0)
                    wr = wins / len(trades)
                    avg_win = np.mean([t["pnl_pct"] for t in trades if t["pnl"] > 0]) if wins > 0 else 0
                    avg_loss = abs(np.mean([t["pnl_pct"] for t in trades if t["pnl"] <= 0])) if (len(trades) - wins) > 0 else 1
                    if avg_loss > 0:
                        kelly_f = max(0, min(1, wr - (1 - wr) / (avg_win / avg_loss)))
                    else:
                        kelly_f = 0.2
                    allocated = capital * kelly_f
                else:
                    allocated = capital * self.position_size_pct

                units = allocated / cost
                position = units
                entry_price = fill_price
                capital -= allocated
                event["type"] = "buy"
                event["units"] = units
                event["capital"] = capital

            elif sig == -1 and position > 0:
                fill_price = price * (1 - self.slippage)
                proceeds = position * fill_price * (1 - self.commission)
                pnl = proceeds - (position * entry_price)
                pnl_pct = pnl / (position * entry_price) if position * entry_price > 0 else 0

                capital += proceeds
                trades.append({"entry": entry_price, "exit": fill_price, "pnl": pnl, "pnl_pct": pnl_pct,
                               "units": position, "entry_date": str(dates[i - 1]), "exit_date": str(dates[i])})
                event["type"] = "sell"
                event["pnl"] = pnl
                event["capital"] = capital
                position = 0
                entry_price = 0

            mark_value = position * price
            equity.append(capital + mark_value)

        if position > 0:
            last_price = float(prices[-1])
            mark_value = position * last_price
            equity[-1] = capital + mark_value

        equity_series = pd.Series(equity, index=self.data.index)
        returns = equity_series.pct_change().dropna()

        total_return = (equity[-1] - self.initial_capital) / self.initial_capital
        ann_return = total_return * (252 / max(len(returns), 1))
        ann_vol = returns.std() * np.sqrt(252) if len(returns) > 1 else 0.0
        sharpe = (ann_return - 0.02) / ann_vol if ann_vol > 0 else 0.0

        peak = equity_series.expanding().max()
        drawdown = (equity_series - peak) / peak
        max_dd = drawdown.min()

        winning = [t for t in trades if t["pnl"] > 0]
        losing = [t for t in trades if t["pnl"] <= 0]
        win_rate = len(winning) / len(trades) if trades else 0.0
        gross_profit = sum(t["pnl"] for t in winning)
        gross_loss = abs(sum(t["pnl"] for t in losing))
        profit_factor = gross_profit / gross_loss if gross_loss > 0 else float("inf") if gross_profit > 0 else 0.0

        return BacktestResult(
            total_return=total_return,
            annualized_return=ann_return,
            annualized_volatility=ann_vol,
            sharpe_ratio=sharpe,
            max_drawdown=max_dd,
            win_rate=win_rate,
            profit_factor=profit_factor,
            total_trades=len(trades),
            winning_trades=len(winning),
            losing_trades=len(losing),
            equity_curve=equity_series,
            trade_log=trades,
        )

    def plot_equity_curve(self, filepath: str = "equity_curve.png"):
        if self.signals is None:
            raise RuntimeError("Run backtest first.")

        result = self.run()
        fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(12, 8), gridspec_kw={"height_ratios": [3, 1]})

        ax1.plot(result.equity_curve.index, result.equity_curve.values, color="#00bcd4", linewidth=1.5, label="Equity")
        ax1.axhline(self.initial_capital, color="gray", linestyle="--", alpha=0.6, label="Initial Capital")
        ax1.fill_between(result.equity_curve.index, self.initial_capital, result.equity_curve.values,
                         where=result.equity_curve.values >= self.initial_capital,
                         color="green", alpha=0.1)
        ax1.fill_between(result.equity_curve.index, self.initial_capital, result.equity_curve.values,
                         where=result.equity_curve.values < self.initial_capital,
                         color="red", alpha=0.1)

        buy_idx = self.signals[self.signals == 1].index
        sell_idx = self.signals[self.signals == -1].index
        buy_prices = self.data.loc[buy_idx, "close"] if len(buy_idx) > 0 else []
        sell_prices = self.data.loc[sell_idx, "close"] if len(sell_idx) > 0 else []

        if len(buy_idx) > 0:
            ax2.scatter(buy_idx, buy_prices, color="lime", marker="^", s=60, label="Buy", zorder=5)
        if len(sell_idx) > 0:
            ax2.scatter(sell_idx, sell_prices, color="red", marker="v", s=60, label="Sell", zorder=5)

        ax2.plot(self.data.index, self.data["close"], color="#00bcd4", linewidth=1, alpha=0.8)
        ax2.set_ylabel("Price")
        ax2.legend(loc="upper left", fontsize=8)
        ax2.grid(alpha=0.3)

        ax1.set_title("Equity Curve", fontsize=13)
        ax1.set_ylabel("Portfolio Value ($)")
        ax1.legend(loc="upper left", fontsize=8)
        ax1.grid(alpha=0.3)

        plt.tight_layout()
        plt.savefig(filepath, dpi=150, bbox_inches="tight")
        plt.close()
        print(f"[+] Equity curve saved to {filepath}")


def load_csv(filepath: str) -> pd.DataFrame:
    """Load OHLCV data from CSV. Expects columns: date,open,high,low,close,volume."""
    df = pd.read_csv(filepath, parse_dates=["date"])
    df.set_index("date", inplace=True)
    df.columns = df.columns.str.lower()
    return df


def load_sample_data() -> pd.DataFrame:
    """Generate synthetic OHLCV data for demo purposes."""
    np.random.seed(42)
    n = 500
    dates = pd.date_range("2023-01-01", periods=n, freq="D")
    returns = np.random.normal(0.0005, 0.015, n)
    close = 100 * np.exp(np.cumsum(returns))
    high = close * (1 + np.abs(np.random.normal(0, 0.008, n)))
    low = close * (1 - np.abs(np.random.normal(0, 0.008, n)))
    open_ = low + np.random.random(n) * (high - low)
    volume = np.random.randint(100_000, 5_000_000, n)
    return pd.DataFrame({"open": open_, "high": high, "low": low, "close": close, "volume": volume}, index=dates)


if __name__ == "__main__":
    from strategies import sma_crossover, rsi_mean_reversion, macd_crossover

    print("[*] Generating sample OHLCV data...")
    df = load_sample_data()

    print("\n" + "=" * 55)
    print("  Strategy 1: SMA Crossover (fast=10, slow=30)")
    print("=" * 55)
    engine = BacktestEngine(df, sma_crossover, initial_capital=10_000, position_size="fixed", position_size_pct=1.0)
    result = engine.run(fast=10, slow=30)
    print(result.summary())
    engine.plot_equity_curve("equity_curve_sma.png")

    print("\n" + "=" * 55)
    print("  Strategy 2: RSI Mean Reversion (period=14, oversold=30, overbought=70)")
    print("=" * 55)
    engine2 = BacktestEngine(df, rsi_mean_reversion, initial_capital=10_000, position_size="fixed", position_size_pct=1.0)
    result2 = engine2.run(period=14, oversold=30, overbought=70)
    print(result2.summary())
    engine2.plot_equity_curve("equity_curve_rsi.png")

    print("\n" + "=" * 55)
    print("  Strategy 3: MACD Crossover (fast=12, slow=26, signal=9)")
    print("=" * 55)
    engine3 = BacktestEngine(df, macd_crossover, initial_capital=10_000, position_size="fixed", position_size_pct=1.0)
    result3 = engine3.run(fast=12, slow=26, signal_period=9)
    print(result3.summary())
    engine3.plot_equity_curve("equity_curve_macd.png")

    print("\n[Done] Backtests complete. Check equity_curve_*.png for charts.")
