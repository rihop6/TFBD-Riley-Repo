use demo;

DROP TABLE datetimetable;
GO

CREATE TABLE [datetimetable] (
	original_date SMALLDATETIME
);
GO

INSERT INTO [datetimetable] (original_date)
VALUES ('2024-07-01 6:32:00');
GO

-- Original table
SELECT original_date
FROM datetimetable;

-- CAST Example
SELECT 
	original_date, 
	CAST(original_date AS TIME) [Casted Time], 
	CAST(original_date AS DATE) [Casted Date]
FROM datetimetable;

-- CONVERT Example
SELECT 
	original_date, 
	CONVERT(DATE, original_date, 3) [UK Time],
	CONVERT(DATE, original_date, 101) [US Time]
FROM datetimetable;

-- DATEPART Example
SELECT 
	original_date, 
	DATEPART(day, original_date) [Day],
	DATEPART(month, original_date) [Month],
	DATEPART(year, original_date) [Year]
FROM datetimetable;

-- DAY/MONTH/YEAR Example
SELECT 
	original_date, 
	DAY(original_date) [Day],
	MONTH(original_date) [Month],
	YEAR(original_date) [Year]
FROM datetimetable;

-- DATEDIFF Example
SELECT 
	original_date, 
	DATEDIFF(day, original_date, '2024-08-01') [Day Diff],
	DATEDIFF(month, original_date, '2024-08-01') [Month Diff],
	DATEDIFF(year, original_date, '2024-08-01') [Year Diff]
FROM datetimetable;

-- DATEADD Example
SELECT 
	original_date, 
	DATEADD(day, 31, original_date) [Day Add],
	DATEADD(month, 1, original_date) [Month Add],
	DATEADD(year, 1, original_date) [Year Add]
FROM datetimetable;