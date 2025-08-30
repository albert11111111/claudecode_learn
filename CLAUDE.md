# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a financial modeling codebase focused on convertible bond pricing using Monte Carlo simulation methods. The project implements Least Squares Monte Carlo (LSM) models for valuing convertible bonds with early exercise features, including call and put provisions.

- **回复时请始终翻译成中文**

## Key Components

### Main File
- `LSM_Convertible_bond/LSM_.py` - Primary implementation containing:
  - Convertible bond data processing and analysis
  - Monte Carlo path generation for stock prices
  - LSM (Least Squares Monte Carlo) algorithm implementation
  - BSM (Black-Scholes-Merton) model for comparison
  - Visualizations and error analysis

### Core Functionality
- **Data Processing**: Import and clean convertible bond data from Excel files
- **Volatility Calculation**: GARCH models and rolling volatility estimates
- **Path Simulation**: Monte Carlo simulation of stock price paths using geometric Brownian motion
- **LSM Algorithm**: Implementation with early exercise decisions for call/put provisions
- **Model Comparison**: LSM vs BSM pricing models with redemption and put features
- **Visualization**: Price charts and error analysis plots

## Dependencies

The codebase uses these key libraries:
- `numpy` - Numerical computations
- `pandas` - Data manipulation
- `matplotlib` - Visualization
- `scikit-learn` - Linear regression for LSM continuation values
- `arch` - GARCH volatility modeling
- `tushare` - Chinese financial data API

## Data Requirements

The code expects data files in `e:\bond\` directory:
- `正在交易可转债数据.xlsx` - Current convertible bond data
- `bond_kzz.csv` - Bond price data
- `利率数据.xls` - Interest rate data (30-year government bonds)
- Stock price data downloaded automatically from NetEase Finance API

## Running the Code

The main script should be run using Windows conda environment:
```bash
# Use Windows timeseries_anomaly environment
/mnt/c/Users/13370/miniconda3/envs/timeseries_anomaly/python.exe LSM_Convertible_bond/LSM_.py

# Or create alias for convenience
alias ts-python="/mnt/c/Users/13370/miniconda3/envs/timeseries_anomaly/python.exe"
ts-python LSM_Convertible_bond/LSM_.py
```

This will:
1. Load bond and stock data
2. Calculate volatilities using GARCH models
3. Run LSM simulations for convertible bond pricing
4. Generate comparison charts and save results to CSV files

## Output Files

- `V_LSM.csv` - LSM model prices
- `V_BSM.csv` - BSM model prices
- `V_BSM_pro.csv` - BSM with call/put features
- `结果.xlsx` - Final results with model comparisons
- PNG charts saved to `e:\bond\` directory