DROP TABLE users;
GO

CREATE TABLE users (
    user_id int PRIMARY KEY IDENTITY,
    user_first_name VARCHAR(30),
    user_last_name VARCHAR(30),
    user_email_id VARCHAR(50),
    user_gender VARCHAR(1),
    user_unique_id VARCHAR(15),
    user_phone_no VARCHAR(20),
    user_dob DATE,
    created_ts DATETIME
);
GO

insert into users (
    user_first_name, user_last_name, user_email_id, user_gender, 
    user_unique_id, user_phone_no, user_dob, created_ts
) VALUES
    ('Giuseppe', 'Bode', 'gbode0@imgur.com', 'M', '88833-8759', 
     '+86 (764) 443-1967', '1973-05-31', '2018-04-15 12:13:38'),
    ('Lexy', 'Gisbey', 'lgisbey1@mail.ru', 'N', '262501-029', 
     '+86 (751) 160-3742', '2003-05-31', '2020-12-29 06:44:09'),
    ('Karel', 'Claringbold', 'kclaringbold2@yale.edu', 'F', '391-33-2823', 
     '+62 (445) 471-2682', '1985-11-28', '2018-11-19 00:04:08'),
    ('Marv', 'Tanswill', 'mtanswill3@dedecms.com', 'F', '1195413-80', 
     '+62 (497) 736-6802', '1998-05-24', '2018-11-19 16:29:43'),
    ('Gertie', 'Espinoza', 'gespinoza4@nationalgeographic.com', 'M', '471-24-6869', 
     '+249 (687) 506-2960', '1997-10-30', '2020-01-25 21:31:10'),
    ('Saleem', 'Danneil', 'sdanneil5@guardian.co.uk', 'F', '192374-933', 
     '+63 (810) 321-0331', '1992-03-08', '2020-11-07 19:01:14'),
    ('Rickert', 'O''Shiels', 'roshiels6@wikispaces.com', 'M', '749-27-47-52', 
     '+86 (184) 759-3933', '1972-11-01', '2018-03-20 10:53:24'),
    ('Cybil', 'Lissimore', 'clissimore7@pinterest.com', 'M', '461-75-4198', 
     '+54 (613) 939-6976', '1978-03-03', '2019-12-09 14:08:30'),
    ('Melita', 'Rimington', 'mrimington8@mozilla.org', 'F', '892-36-676-2', 
     '+48 (322) 829-8638', '1995-12-15', '2018-04-03 04:21:33'),
    ('Benetta', 'Nana', 'bnana9@google.com', 'N', '197-54-1646', 
     '+420 (934) 611-0020', '1971-12-07', '2018-10-17 21:02:51'),
    ('Gregorius', 'Gullane', 'ggullanea@prnewswire.com', 'F', '232-55-52-58', 
     '+62 (780) 859-1578', '1973-09-18', '2020-01-14 23:38:53'),
    ('Una', 'Glayzer', 'uglayzerb@pinterest.com', 'M', '898-84-336-6', 
     '+380 (840) 437-3981', '1983-05-26', '2019-09-17 03:24:21'),
    ('Jamie', 'Vosper', 'jvosperc@umich.edu', 'M', '247-95-68-44', 
     '+81 (205) 723-1942', '1972-03-18', '2020-07-23 16:39:33'),
    ('Calley', 'Tilson', 'ctilsond@issuu.com', 'F', '415-48-894-3', 
     '+229 (698) 777-4904', '1987-06-12', '2020-06-05 12:10:50'),
    ('Peadar', 'Gregorowicz', 'pgregorowicze@omniture.com', 'M', '403-39-5-869', 
     '+7 (267) 853-3262', '1996-09-21', '2018-05-29 23:51:31'),
    ('Jeanie', 'Webling', 'jweblingf@booking.com', 'F', '399-83-05-03', 
     '+351 (684) 413-0550', '1994-12-27', '2018-02-09 01:31:11'),
    ('Yankee', 'Jelf', 'yjelfg@wufoo.com', 'F', '607-99-0411', 
     '+1 (864) 112-7432', '1988-11-13', '2019-09-16 16:09:12'),
    ('Blair', 'Aumerle', 'baumerleh@toplist.cz', 'F', '430-01-578-5', 
     '+7 (393) 232-1860', '1979-11-09', '2018-10-28 19:25:35'),
    ('Pavlov', 'Steljes', 'psteljesi@macromedia.com', 'F', '571-09-6181', 
     '+598 (877) 881-3236', '1991-06-24', '2020-09-18 05:34:31'),
    ('Darn', 'Hadeke', 'dhadekej@last.fm', 'M', '478-32-02-87', 
     '+370 (347) 110-4270', '1984-09-04', '2018-02-10 12:56:00'),
    ('Wendell', 'Spanton', 'wspantonk@de.vu', 'F', null, 
     '+84 (301) 762-1316', '1973-07-24', '2018-01-30 01:20:11'),
    ('Carlo', 'Yearby', 'cyearbyl@comcast.net', 'F', null, 
     '+55 (288) 623-4067', '1974-11-11', '2018-06-24 03:18:40'),
    ('Sheila', 'Evitts', 'sevittsm@webmd.com', null, '830-40-5287',
     null, '1977-03-01', '2020-07-20 09:59:41'),
    ('Sianna', 'Lowdham', 'slowdhamn@stanford.edu', null, '778-0845', 
     null, '1985-12-23', '2018-06-29 02:42:49'),
    ('Phylys', 'Aslie', 'paslieo@qq.com', 'M', '368-44-4478', 
     '+86 (765) 152-8654', '1984-03-22', '2019-10-01 01:34:28')
GO

SELECT * FROM users;

-- Exercise 1
SELECT
	FORMAT(users.created_ts, 'yyyy') AS [created_year],
	COUNT(users.user_id) AS [user_count]
FROM users
GROUP BY
	FORMAT(users.created_ts, 'yyyy')
ORDER BY
	FORMAT(users.created_ts, 'yyyy') ASC;

-- Exercise 2 (the exercise says both May and June- I chose May)
SELECT
	users.user_id,
	users.user_dob,
	users.user_email_id,
	DATENAME(dw, users.user_dob) AS [user_day_of_birth]
FROM
	users
WHERE
	FORMAT(users.user_dob, 'MM') LIKE '%05%'
ORDER BY
	FORMAT(users.user_dob, 'dd') ASC;

-- Exercise 3
SELECT
	users.user_id,
	CONCAT(users.user_first_name, ' ', users.user_last_name) AS [user_name],
	users.user_email_id,
	users.created_ts,
	FORMAT(users.created_ts, 'yyyy') AS [created_year]
FROM
	users
WHERE
	FORMAT(users.created_ts, 'yyyy') LIKE '%2019%'
ORDER BY
	CONCAT(users.user_first_name, users.user_last_name) ASC;

-- Exercise 4
SELECT
	user_gender = CASE users.user_gender
		WHEN 'M' THEN 'Male'
		WHEN 'F' THEN 'Female'
		WHEN 'N' THEN 'Non-Binary'
		ELSE 'Not Specified'
		END,
	COUNT(users.user_id) AS [user_count]
FROM
	users
GROUP BY
	CASE users.user_gender
		WHEN 'M' THEN 'Male'
		WHEN 'F' THEN 'Female'
		WHEN 'N' THEN 'Non-Binary'
		WHEN NULL THEN 'Not Specified'
		ELSE 'Not Specified'
		END
ORDER BY
	COUNT(users.user_id) DESC;

-- Exercise 5
SELECT
	users.user_id,
	users.user_unique_id,
	CASE
		WHEN LEN(REPLACE(users.user_unique_id, '-', '')) >= 9 THEN RIGHT(REPLACE(users.user_unique_id, '-', ''), 4)
		WHEN LEN(REPLACE(users.user_unique_id, '-', '')) < 9 THEN 'Invalid Unique Id'
		ELSE 'Not Specified'
	END AS user_unique_id_last4
FROM users
ORDER BY
	users.user_id ASC;

-- Exercise 6
SELECT
	REPLACE(LEFT(users.user_phone_no, charindex(' ', users.user_phone_no) - 1), '+', '') AS [country_code],
	COUNT(users.user_id)
FROM
	users
WHERE 
	users.user_phone_no IS NOT NULL
GROUP BY
	REPLACE(LEFT(users.user_phone_no, charindex(' ', users.user_phone_no) - 1), '+', '')
ORDER BY
	CAST(REPLACE(LEFT(users.user_phone_no, charindex(' ', users.user_phone_no) - 1), '+', '') AS int) ASC;

-- Exercise 7
USE retail_db;

SELECT
	COUNT(1) [count]
FROM 
	order_items oi
WHERE
	CAST(order_item_quantity * order_item_product_price AS DECIMAL(18,2)) != CAST(order_item_subtotal AS DECIMAL(18,2));

-- Exercise 8
SELECT
	CASE
		WHEN DATEPART(dw, order_date) IN (1, 7) THEN 'Weekend days'
		ELSE 'Week days'
	END AS day_type,
	COUNT(order_id) AS order_count
FROM
	orders
WHERE
	format(order_date, 'yyyy-MM') LIKE '2014-01%'
GROUP BY
	CASE
		WHEN DATEPART(dw, order_date) IN (1, 7) THEN 'Weekend days'
		ELSE 'Week days'
	END;