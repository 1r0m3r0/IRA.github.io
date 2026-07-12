#!/usr/bin/env pwsh
# Setup script to create 4 GitHub repos from local projects
# Run after: gh auth login
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    $env:Path = [Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [Environment]::GetEnvironmentVariable("Path","User")
}

Write-Host "Checking gh auth..." -ForegroundColor Cyan
gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Please run 'gh auth login' first!" -ForegroundColor Red
    exit 1
}

$repos = @(
    @{Name="crypto-screener"; Desc="Python CLI tool to scan CoinGecko API for crypto trading opportunities. Real-time RSI, volume/mcap filters, CSV export."},
    @{Name="backtest-engine"; Desc="Python backtesting framework for trading strategies. SMA crossover, RSI, MACD. Sharpe ratio, max drawdown, equity curve."},
    @{Name="portfolio-optimizer"; Desc="Python Markowitz portfolio optimization. Monte Carlo simulation, efficient frontier, max Sharpe ratio, optimal weights."},
    @{Name="sentiment-dashboard"; Desc="JavaScript real-time crypto market sentiment dashboard. Fear & Greed gauge, trending coins, interactive charts."}
)

foreach ($repo in $repos) {
    $name = $repo.Name
    $desc = $repo.Desc
    $dir = Join-Path $PSScriptRoot $name
    
    Write-Host "`n=== Creating $name ===" -ForegroundColor Green
    
    # Create GitHub repo
    gh repo create "1r0m3r0/$name" --public --description $desc --source="$dir" --push 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to create $name" -ForegroundColor Red
        continue
    }
    Write-Host "Done: https://github.com/1r0m3r0/$name" -ForegroundColor Yellow
}

Write-Host "`n=== ALL DONE ===" -ForegroundColor Green
Write-Host "Verify at: https://github.com/1r0m3r0?tab=repositories"
