USE retail_db

-- Exercise 1
SELECT 
	c.customer_id,
	c.customer_fname,
	c.customer_lname,
	COUNT(o.order_id) AS order_count
FROM 
	customers c
JOIN 
	orders o ON c.customer_id = o.order_customer_id
WHERE 
	format(order_date, 'yyyy-MM') LIKE '2014-01%'
GROUP BY 
	c.customer_id, c.customer_fname, c.customer_lname
ORDER BY 
	order_count desc, c.customer_id asc;

-- Exercise 2
SELECT 
	c.*, order_id, order_date
FROM 
	customers c
LEFT JOIN 
	orders o ON c.customer_id = o.order_customer_id
	AND format(o.order_date, 'yyyy-MM') LIKE '2014-01%'
WHERE o.order_id IS NULL
ORDER BY c.customer_id asc;

-- Exercise 3
SELECT 
    c.customer_id,
    c.customer_fname,
    c.customer_lname,
    COALESCE(SUM(oi.order_item_subtotal),0) AS customer_revenue
FROM 
	customers c
LEFT JOIN 
    orders o ON c.customer_id = o.order_customer_id
	AND format(o.order_date, 'yyyy-MM') LIKE '2014-01%'
	AND (o.order_status LIKE '%complete%'
	OR o.order_status LIKE '%closed%')
LEFT JOIN 
    order_items oi ON o.order_id = oi.order_item_order_id
GROUP BY 
    c.customer_id, c.customer_fname, c.customer_lname
ORDER BY 
    customer_revenue DESC,
    c.customer_id ASC;

-- Exercise 4
SELECT 
    c.*,
    COALESCE(SUM(oi.order_item_subtotal),0) AS category_revenue
FROM 
	categories c
LEFT JOIN
	products p ON c.category_id = p.product_category_id
LEFT JOIN 
    order_items oi ON p.product_id = oi.order_item_product_id
LEFT JOIN 
    orders o ON oi.order_item_order_id = o.order_id
	AND format(o.order_date, 'yyyy-MM') LIKE '2014-01%'
	AND (o.order_status LIKE '%complete%'
	OR o.order_status LIKE '%closed%')
GROUP BY 
    c.category_id,
	c.category_department_id,
	c.category_name
ORDER BY 
    category_id ASC;

-- Exercise 5
SELECT
	d.*,
	COUNT(p.product_id) AS product_count
FROM departments d
LEFT JOIN
	categories c ON d.department_id = c.category_department_id
LEFT JOIN
	products p ON c.category_id = p.product_category_id
GROUP BY 
    d.department_id,
	d.department_name
ORDER BY 
    d.department_id ASC;