#!/usr/bin/env python3
"""
Example trading strategies for the Backtest Engine.
Each function accepts a DataFrame with OHLCV columns and returns a pd.Series of
signals: 1 = buy, -1 = sell, 0 = hold.
"""

import numpy as np
import pandas as pd


def sma_crossover(df: pd.DataFrame, fast: int = 10, slow: int = 30) -> pd.Series:
    """
    Simple Moving Average Crossover strategy.
    Buy when fast SMA crosses above slow SMA.
    Sell when fast SMA crosses below slow SMA.

    Parameters
    ----------
    df : pd.DataFrame
        OHLCV data with 'close' column.
    fast : int
        Fast SMA period.
    slow : int
        Slow SMA period.

    Returns
    -------
    pd.Series : 1 (buy), -1 (sell), 0 (hold).
    """
    close = df["close"]
    sma_fast = close.rolling(window=fast).mean()
    sma_slow = close.rolling(window=slow).mean()

    signals = pd.Series(0, index=df.index, dtype=int)

    cross_above = (sma_fast > sma_slow) & (sma_fast.shift(1) <= sma_slow.shift(1))
    cross_below = (sma_fast < sma_slow) & (sma_fast.shift(1) >= sma_slow.shift(1))

    signals[cross_above] = 1
    signals[cross_below] = -1

    return signals


def rsi_mean_reversion(
    df: pd.DataFrame, period: int = 14, oversold: int = 30, overbought: int = 70
) -> pd.Series:
    """
    RSI Mean Reversion strategy.
    Buy when RSI crosses above the oversold threshold.
    Sell when RSI crosses below the overbought threshold.

    Parameters
    ----------
    df : pd.DataFrame
        OHLCV data with 'close' column.
    period : int
        RSI calculation period.
    oversold : int
        Oversold threshold.
    overbought : int
        Overbought threshold.

    Returns
    -------
    pd.Series : 1 (buy), -1 (sell), 0 (hold).
    """
    close = df["close"]
    delta = close.diff()

    gain = delta.where(delta > 0, 0.0)
    loss = (-delta).where(delta < 0, 0.0)

    avg_gain = gain.ewm(alpha=1 / period, adjust=False).mean()
    avg_loss = loss.ewm(alpha=1 / period, adjust=False).mean()

    rs = avg_gain / avg_loss.replace(0, np.nan)
    rsi = 100.0 - (100.0 / (1.0 + rs))

    signals = pd.Series(0, index=df.index, dtype=int)

    buy_signal = (rsi.shift(1) < oversold) & (rsi >= oversold)
    sell_signal = (rsi.shift(1) > overbought) & (rsi <= overbought)

    signals[buy_signal] = 1
    signals[sell_signal] = -1

    return signals


def macd_crossover(
    df: pd.DataFrame, fast: int = 12, slow: int = 26, signal_period: int = 9
) -> pd.Series:
    """
    MACD Signal Line Crossover strategy.
    Buy when MACD line crosses above the signal line.
    Sell when MACD line crosses below the signal line.

    Parameters
    ----------
    df : pd.DataFrame
        OHLCV data with 'close' column.
    fast : int
        Fast EMA period.
    slow : int
        Slow EMA period.
    signal_period : int
        Signal line EMA period.

    Returns
    -------
    pd.Series : 1 (buy), -1 (sell), 0 (hold).
    """
    close = df["close"]
    ema_fast = close.ewm(span=fast, adjust=False).mean()
    ema_slow = close.ewm(span=slow, adjust=False).mean()

    macd_line = ema_fast - ema_slow
    signal_line = macd_line.ewm(span=signal_period, adjust=False).mean()
    histogram = macd_line - signal_line

    signals = pd.Series(0, index=df.index, dtype=int)

    cross_above = (macd_line > signal_line) & (macd_line.shift(1) <= signal_line.shift(1))
    cross_below = (macd_line < signal_line) & (macd_line.shift(1) >= signal_line.shift(1))

    signals[cross_above] = 1
    signals[cross_below] = -1

    return signals


def bollinger_bands_reversal(
    df: pd.DataFrame, period: int = 20, std_dev: float = 2.0
) -> pd.Series:
    """
    Bollinger Bands mean reversion strategy.
    Buy when price crosses below the lower band.
    Sell when price crosses above the upper band.

    Parameters
    ----------
    df : pd.DataFrame
        OHLCV data with 'close' column.
    period : int
        SMA period for the middle band.
    std_dev : float
        Number of standard deviations for bands.

    Returns
    -------
    pd.Series : 1 (buy), -1 (sell), 0 (hold).
    """
    close = df["close"]
    middle = close.rolling(window=period).mean()
    std = close.rolling(window=period).std()

    upper = middle + std_dev * std
    lower = middle - std_dev * std

    signals = pd.Series(0, index=df.index, dtype=int)

    touch_lower = (close.shift(1) > lower.shift(1)) & (close <= lower)
    touch_upper = (close.shift(1) < upper.shift(1)) & (close >= upper)

    signals[touch_lower] = 1
    signals[touch_upper] = -1

    return signals


if __name__ == "__main__":
    from engine import load_sample_data

    df = load_sample_data()
    print("Sample data shape:", df.shape)

    sig_sma = sma_crossover(df, fast=10, slow=30)
    sig_rsi = rsi_mean_reversion(df, period=14, oversold=30, overbought=70)
    sig_macd = macd_crossover(df, fast=12, slow=26, signal_period=9)
    sig_bb = bollinger_bands_reversal(df, period=20, std_dev=2.0)

    for name, sig in [("SMA Crossover", sig_sma), ("RSI MR", sig_rsi), ("MACD", sig_macd), ("Bollinger", sig_bb)]:
        buys = (sig == 1).sum()
        sells = (sig == -1).sum()
        print(f"  {name}: {buys} buys, {sells} sells")
