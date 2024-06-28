/*

Partitioning
3 main strategies:
- Hash
- List
- Range

SQL Server only supports Range

0. Optional - Create our filegroups
1. Create our partition function
2. Create our partition scheme
3. Create or alter our tables to specify the partition column

*/

CREATE DATABASE partition_demo
GO

USE partition_demo;
GO

-- Partition Function
-- RANGE RIGHT OR LEFT
-- LEFT STARTS LEFT BOUND (ex. before april 1st) RIGHT IS RIGHT BOUND (april 1st and after)
CREATE PARTITION FUNCTION myRangePF1 (datetime2(0))
	AS RANGE RIGHT FOR VALUES ('2022-04-01', '2022-05-01', '2022-06-01')
GO

-- Partition Scheme
CREATE PARTITION SCHEME myRangePS1
	AS PARTITION myRangePF1
	ALL TO ('PRIMARY');
GO

-- Create PartitionTable
DROP TABLE PartitionTable;
GO
CREATE TABLE dbo.PartitionTable(col1 datetime2(0) PRIMARY KEY, col2 char(20))
	ON myRangePS1(col1);
GO

SELECT * FROM PartitionTable;
GO

-- Example 2
-- Partition Function
CREATE PARTITION FUNCTION myRangePF2 (INT)
	AS RANGE RIGHT FOR VALUES (1, 100, 1000);
GO

-- Partition Scheme
CREATE PARTITION SCHEME myRangePS2
	AS PARTITION myRangePF2
	ALL TO ('PRIMARY');
GO

-- Recreate Partition Table
DROP TABLE PartitionTable;
GO
CREATE TABLE dbo.PartitionTable(col1 INT PRIMARY KEY, col2 char(20))
	ON myRangePS2(col1);
GO

SELECT * FROM PartitionTable;
GO

-- Merge a boundary
ALTER PARTITION FUNCTION myRangePF2()
MERGE RANGE(100);
GO

-- Create a new boundary
ALTER PARTITION FUNCTION myRangePF2()
SPLIT RANGE(500);
GO

/* 

Find boundaries, schema, etc using commands here
https://learn.microsoft.com/en-us/sql/relational-databases/partitions/create-partitioned-tables-and-indexes?view=sql-server-ver16 

*/
-- Determine if table is partitioned
SELECT SCHEMA_NAME(t.schema_id) AS SchemaName, *   
FROM sys.tables AS t   
JOIN sys.indexes AS i   
    ON t.[object_id] = i.[object_id]   
JOIN sys.partition_schemes ps   
    ON i.data_space_id = ps.data_space_id   
WHERE t.name = 'PartitionTable';   
GO

-- Determine boundaries of partition
SELECT SCHEMA_NAME(t.schema_id) AS SchemaName, t.name AS TableName, i.name AS IndexName, 
    p.partition_number, p.partition_id, i.data_space_id, f.function_id, f.type_desc, 
    r.boundary_id, r.value AS BoundaryValue   
FROM sys.tables AS t  
JOIN sys.indexes AS i  
    ON t.object_id = i.object_id  
JOIN sys.partitions AS p  
    ON i.object_id = p.object_id AND i.index_id = p.index_id   
JOIN  sys.partition_schemes AS s   
    ON i.data_space_id = s.data_space_id  
JOIN sys.partition_functions AS f   
    ON s.function_id = f.function_id  
LEFT JOIN sys.partition_range_values AS r   
    ON f.function_id = r.function_id and r.boundary_id = p.partition_number  
WHERE 
    t.name = 'PartitionTable' 
    AND i.type <= 1  
ORDER BY SchemaName, t.name, i.name, p.partition_number;
GO

/*

Analytics Functions

Window Functions

Types
- GLOBAL: func() OVER (ORDER BY <col>)
- Aggregations: func() OVER (PARTITION BY <col>)
- Local: func() OVER (PARTITION BY <col> ORDER BY <col>)

*/

USE hr_db;

-- Get all of the total salaries of each department
SELECT department_id, SUM(salary) dept_salary
FROM employees
GROUP BY employee_id, department_id

-- Compare each employees salary to the total average salary of their department
-- Traditional way: subquery... avoid using

-- Rewrite it with window functions
SELECT TOP 10
	employee_id,
	department_id,
	salary,
	SUM(salary) OVER (PARTITION BY department_id ORDER BY department_id DESC) total_dept_salary,
	AVG(salary) OVER (PARTITION BY department_id) avg_dept_salary,
	salary/SUM(salary) OVER (PARTITION BY department_id) pct_dept_salary
FROM employees

USE retail_db;

-- Daily Revenue Table CTAS (Create Table as Select)
/*
NEED LECTURE NOTES HERE
*/
SELECT
	o.order_date,
	oi.order_item_product_id,
	CAST(SUM(oi.order_item_subtotal) OVER(PARTITION BY oi.order_item_product_id ORDER BY o.order_date) AS DECIMAL(18,2)) revenue
--INTO daily_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_item_order_id
WHERE (o.order_status LIKE '%complete%'
	OR o.order_status LIKE '%closed%')
--GROUP BY o.order_date, oi.order_item_product_id;

-- Now we can analyze based off window functions
SELECT 
	*,
	SUM(revenue) OVER (PARTITION BY order_date) total_daily_revenue,
	MIN(revenue) OVER (PARTITION BY order_date) min_daily_revenue,
	MAX(revenue) OVER (PARTITION BY order_date) max_daily_revenue
FROM daily_product_revenue
ORDER BY order_item_product_id, order_date;

SELECT 
	*,
	SUM(revenue) OVER (PARTITION BY order_date) total_daily_revenue,
	MIN(revenue) OVER (PARTITION BY order_date) min_daily_revenue,
	MAX(revenue) OVER (PARTITION BY order_date) max_daily_revenue,
	MAX(revenue) OVER (PARTITION BY order_item_product_id) max_product_revenue
FROM daily_product_revenue
ORDER BY order_item_product_id, order_date;

-- Cumulative Aggregation vs Moving Aggregation