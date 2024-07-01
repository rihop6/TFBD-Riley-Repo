USE retail_db;

SELECT * FROM products;
SELECT * FROM categories;
SELECT * FROM customers;
SELECT * FROM orders;

-- Exercise 1
SELECT
    c.category_name
FROM
    categories c
WHERE
    (SELECT COUNT(*)
     FROM products p
     WHERE p.product_category_id = c.category_id) > 5;

-- Exercise 2
SELECT
	o.*, sub.order_count
FROM
	(SELECT
		order_customer_id,
		COUNT(order_id) AS order_count
	FROM
		orders
	GROUP BY
		order_customer_id) sub
LEFT JOIN orders o ON o.order_customer_id = sub.order_customer_id
WHERE sub.order_count > 10;

-- Exercise 3
/*
I have run out of time for this, I tried my best... I got stuck on quite a few problems
for way too long. I'm still struggling to wrap my head around SQL- I'll try to review
some of the lecture videos.
*/