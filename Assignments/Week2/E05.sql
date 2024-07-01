USE retail_db;

-- Exercise 1
-- Partition Function
-- RANGE RIGHT OR LEFT
-- LEFT STARTS LEFT BOUND (ex. before april 1st) RIGHT IS RIGHT BOUND (april 1st and after)
--Create date partition function with increment by month.  
DROP TABLE orders_part;
DROP PARTITION SCHEME myRangePS1;
DROP PARTITION FUNCTION dateRangePF;


CREATE PARTITION FUNCTION [dateRangePF] (datetime2(0))
AS RANGE RIGHT FOR VALUES ('2013-01-01', '2013-02-01', '2013-03-01',
               '2013-04-01', '2013-05-01', '2013-06-01', '2013-07-01',   
               '2013-08-01', '2013-09-01', '2013-10-01', '2013-11-01',
			   '2013-12-01', '2014-01-01', '2014-02-01', '2014-03-01',  
               '2014-04-01', '2014-05-01', '2014-06-01', '2014-07-01',   
               '2014-08-01', '2014-09-01', '2014-10-01', '2014-11-01',
			   '2014-12-01');

-- Partition Scheme
CREATE PARTITION SCHEME myRangePS1
	AS PARTITION dateRangePF
	ALL TO ('PRIMARY');
GO

CREATE TABLE dbo.orders_part(order_id int NOT NULL, order_date datetime2(0) NOT NULL, order_customer_id int, order_status varchar(30))
	ON myRangePS1(order_date);
GO
ALTER TABLE orders_part
ADD PRIMARY KEY (order_id,order_date);

SELECT * FROM orders_part;
GO

-- Determine if table is partitioned
SELECT SCHEMA_NAME(t.schema_id) AS SchemaName, *   
FROM sys.tables AS t   
JOIN sys.indexes AS i   
    ON t.[object_id] = i.[object_id]   
JOIN sys.partition_schemes ps   
    ON i.data_space_id = ps.data_space_id   
WHERE t.name = 'orders_part';   
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
    t.name = 'orders_part' 
    AND i.type <= 1  
ORDER BY SchemaName, t.name, i.name, p.partition_number;
GO

-- Exercise 2
INSERT INTO orders_part
SELECT *
FROM orders o;

SELECT
	COUNT(1) [Order Count]
FROM
	orders_part;