USE StocksPortfolio

-- Create the stocks table
DROP TABLE stocks;
CREATE TABLE stocks (
    symbol VARCHAR(10) NOT NULL,
	initial_investment FLOAT NOT NULL,
	shares_bought FLOAT,
	total_return FLOAT,
	volatility FLOAT,
	avg_return FLOAT,
	sharpe_ratio FLOAT
);
GO

-- Declare Variables

-- Initial Investment
DECLARE @Investment FLOAT = 100000;

-- Buying Price of ETF
DECLARE @etf_buyprice FLOAT;
SELECT TOP 1 @etf_buyprice = stockdata.Close_Price
FROM stockdata
WHERE stockdata.Symbol = 'WGMI'
ORDER BY Date ASC;

-- Buying Price of NVDA
DECLARE @nvda_buyprice FLOAT;
SELECT TOP 1 @nvda_buyprice = stockdata.Close_Price
FROM stockdata
WHERE stockdata.Symbol = 'NVDA'
ORDER BY Date ASC;

-- Buying Price of FOREX
DECLARE @forex_buyprice FLOAT;
SELECT TOP 1 @forex_buyprice = stockdata.Close_Price
FROM stockdata
WHERE stockdata.Symbol = 'C:EURUSD'
ORDER BY Date ASC;

-- Buying Price of INDEX
DECLARE @index_buyprice FLOAT;
SELECT TOP 1 @index_buyprice = stockdata.Close_Price
FROM stockdata
WHERE stockdata.Symbol = 'NDX'
ORDER BY Date ASC;

-- Insert into overall stocks table
INSERT INTO stocks
    (symbol, initial_investment, shares_bought)
VALUES
    ('WGMI', @Investment/4.0, (@Investment/4.0)/@etf_buyprice),
	('NVDA', @Investment/4.0, (@Investment/4.0)/@nvda_buyprice),
	('C:EURUSD', @Investment/4.0, (@Investment/4.0)/@forex_buyprice),
	('NDX', @Investment/4.0, (@Investment/4.0)/@index_buyprice);

-- Cumulative Returns and moving averages
DROP TABLE cumulative_returns;
SELECT
	d.Symbol,
	d.[Date],
	(((s.shares_bought * d.Close_Price)-s.initial_investment)/@Investment)*100 AS [Cumulative Return],
	AVG((((s.shares_bought * d.Close_Price)-s.initial_investment)/@Investment)*100) OVER (
		PARTITION BY d.Symbol
        ORDER BY Date
        ROWS BETWEEN 5 PRECEDING AND 4 FOLLOWING
    ) AS moving_avg_10_day,
	AVG((((s.shares_bought * d.Close_Price)-s.initial_investment)/@Investment)*100) OVER (
		PARTITION BY d.Symbol
        ORDER BY Date
        ROWS BETWEEN 50 PRECEDING AND 49 FOLLOWING
    ) AS moving_avg_100_day
INTO cumulative_returns
FROM stockdata d
LEFT JOIN stocks s ON s.symbol = d.symbol;

SELECT *
FROM cumulative_returns;

-- Update each stock with its total return, volatility, and average return
UPDATE stocks
SET
	total_return = (
		SELECT TOP 1 [Cumulative Return]
		FROM cumulative_returns
		WHERE Symbol = 'WGMI'
		ORDER BY Date DESC),
	volatility = (
		SELECT STDEV([Cumulative Return])
		FROM cumulative_returns
		WHERE Symbol = 'WGMI'),
	avg_return = (
		SELECT AVG([Cumulative Return])
		FROM cumulative_returns
		WHERE Symbol = 'WGMI')
WHERE symbol = 'WGMI';

UPDATE stocks
SET
	total_return = (
		SELECT TOP 1 [Cumulative Return]
		FROM cumulative_returns
		WHERE Symbol = 'NVDA'
		ORDER BY Date DESC),
	volatility = (
		SELECT STDEV([Cumulative Return])
		FROM cumulative_returns
		WHERE Symbol = 'NVDA'),
	avg_return = (
		SELECT AVG([Cumulative Return])
		FROM cumulative_returns
		WHERE Symbol = 'NVDA')
WHERE symbol = 'NVDA';

UPDATE stocks
SET
	total_return = (
		SELECT TOP 1 [Cumulative Return]
		FROM cumulative_returns
		WHERE Symbol = 'C:EURUSD'
		ORDER BY Date DESC),
	volatility = (
		SELECT STDEV([Cumulative Return])
		FROM cumulative_returns
		WHERE Symbol = 'C:EURUSD'),
	avg_return = (
		SELECT AVG([Cumulative Return])
		FROM cumulative_returns
		WHERE Symbol = 'C:EURUSD')
WHERE symbol = 'C:EURUSD';

UPDATE stocks
SET
	total_return = (
		SELECT TOP 1 [Cumulative Return]
		FROM cumulative_returns
		WHERE Symbol = 'NDX'
		ORDER BY Date DESC),
	volatility = (
		SELECT STDEV([Cumulative Return])
		FROM cumulative_returns
		WHERE Symbol = 'NDX'),
	avg_return = (
		SELECT AVG([Cumulative Return])
		FROM cumulative_returns
		WHERE Symbol = 'NDX')
WHERE symbol = 'NDX';

-- Use the risk free return to calculate sharpe index
DECLARE @risk_free FLOAT;
SELECT @risk_free = avg_return
FROM stocks
WHERE Symbol = 'NDX'

-- Add portfolio row
INSERT INTO stocks
    (symbol, initial_investment)
VALUES
    ('PORTFOLIO', @Investment)

UPDATE stocks
SET
	shares_bought = (
		SELECT SUM(shares_bought)
		FROM stocks),
	total_return = (
		SELECT SUM(total_return)
		FROM stocks),
	volatility = (
		SELECT AVG(volatility)
		FROM stocks),
	avg_return = (
		SELECT AVG(avg_return)
		FROM stocks)
WHERE Symbol = 'PORTFOLIO';

-- Calculate sharpe ratios
UPDATE stocks
SET sharpe_ratio = (avg_return - @risk_free)/volatility

SELECT * FROM stocks;