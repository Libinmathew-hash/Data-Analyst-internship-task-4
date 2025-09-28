-- =====================================
-- Clean start: Drop old tables
-- =====================================
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;

-- =====================================
-- Create tables
-- =====================================
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    product_id INT,
    total_amount DECIMAL(10,2),
    order_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- =====================================
-- Insert sample users
-- =====================================
INSERT INTO users (user_id, name, email, country) VALUES
(101,'Alice','alice@example.com','USA'),
(102,'Bob','bob@example.com','UK'),
(103,'Charlie','charlie@example.com','Canada'),
(104,'David','david@example.com','USA'),
(105,'Eva','eva@example.com','India'),
(106,'Frank','frank@example.com','Germany'),
(107,'Grace','grace@example.com','Australia'),
(108,'Hannah','hannah@example.com','UK'),
(109,'Ivan','ivan@example.com','Russia'),
(110,'Judy','judy@example.com','India');

-- =====================================
-- Insert sample products
-- =====================================
INSERT INTO products (product_id, product_name, category, price) VALUES
(501,'Laptop','Electronics',1000),
(502,'Phone','Electronics',500),
(503,'Book','Education',50),
(504,'Headphones','Electronics',150),
(505,'Backpack','Accessories',80),
(506,'Tablet','Electronics',300),
(507,'Camera','Electronics',700),
(508,'Shoes','Fashion',120),
(509,'Watch','Accessories',200),
(510,'Notebook','Education',20);

-- =====================================
-- Insert sample orders (50+ rows)
-- =====================================
INSERT INTO orders (order_id, user_id, product_id, total_amount, order_date) VALUES
(1,101,501,1000,'2025-01-01'),
(2,102,502,500,'2025-01-02'),
(3,103,503,50,'2025-01-03'),
(4,101,504,150,'2025-01-04'),
(5,104,505,80,'2025-01-05'),
(6,105,503,50,'2025-01-06'),
(7,102,504,150,'2025-01-07'),
(8,101,502,500,'2025-01-08'),
(9,103,505,80,'2025-01-09'),
(10,105,501,1000,'2025-01-10'),
(11,106,506,300,'2025-01-11'),
(12,107,507,700,'2025-01-12'),
(13,108,508,120,'2025-01-13'),
(14,109,509,200,'2025-01-14'),
(15,110,510,20,'2025-01-15'),
(16,101,503,50,'2025-01-16'),
(17,102,506,300,'2025-01-17'),
(18,103,501,1000,'2025-01-18'),
(19,104,502,500,'2025-01-19'),
(20,105,507,700,'2025-01-20'),
(21,106,504,150,'2025-01-21'),
(22,107,505,80,'2025-01-22'),
(23,108,503,50,'2025-01-23'),
(24,109,506,300,'2025-01-24'),
(25,110,501,1000,'2025-01-25'),
(26,101,508,120,'2025-01-26'),
(27,102,509,200,'2025-01-27'),
(28,103,510,20,'2025-01-28'),
(29,104,504,150,'2025-01-29'),
(30,105,505,80,'2025-01-30'),
(31,106,503,50,'2025-01-31'),
(32,107,506,300,'2025-02-01'),
(33,108,501,1000,'2025-02-02'),
(34,109,502,500,'2025-02-03'),
(35,110,507,700,'2025-02-04'),
(36,101,504,150,'2025-02-05'),
(37,102,505,80,'2025-02-06'),
(38,103,503,50,'2025-02-07'),
(39,104,506,300,'2025-02-08'),
(40,105,501,1000,'2025-02-09'),
(41,106,508,120,'2025-02-10'),
(42,107,509,200,'2025-02-11'),
(43,108,510,20,'2025-02-12'),
(44,109,504,150,'2025-02-13'),
(45,110,505,80,'2025-02-14'),
(46,101,503,50,'2025-02-15'),
(47,102,506,300,'2025-02-16'),
(48,103,501,1000,'2025-02-17'),
(49,104,502,500,'2025-02-18'),
(50,105,507,700,'2025-02-19');

-- =====================================
-- Create view for total revenue per user
-- =====================================
CREATE OR REPLACE VIEW user_total_revenue AS
SELECT u.name AS user_name, SUM(o.total_amount) AS total_revenue
FROM orders o
JOIN users u ON o.user_id = u.user_id
GROUP BY u.name;

-- =====================================
-- Queries for screenshots
-- =====================================

-- 1. All users
SELECT * FROM users;

-- 2. All products
SELECT * FROM products;

-- 3. All orders
SELECT * FROM orders;

-- 4. Total revenue per user
SELECT * FROM user_total_revenue;

-- 5. Average revenue per user
SELECT user_id, AVG(total_amount) AS avg_revenue
FROM orders
GROUP BY user_id;

-- 6. Users with revenue above average
SELECT user_id, SUM(total_amount) AS total_revenue
FROM orders
GROUP BY user_id
HAVING total_revenue > (SELECT AVG(total_amount) FROM orders);

-- 7. Orders with user and product details
SELECT o.order_id, u.name AS user_name, u.country, p.product_name, p.category, o.total_amount, o.order_date
FROM orders o
INNER JOIN users u ON o.user_id = u.user_id
INNER JOIN products p ON o.product_id = p.product_id;

-- 8. Users with their orders (LEFT JOIN)
SELECT u.user_id, u.name, o.order_id, o.total_amount, o.order_date
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id;

-- 9. Total revenue per country
SELECT u.country, SUM(o.total_amount) AS country_revenue
FROM orders o
JOIN users u ON o.user_id = u.user_id
GROUP BY u.country
ORDER BY country_revenue DESC;

-- 10. Top 5 products by revenue
SELECT p.product_name, SUM(o.total_amount) AS product_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY product_revenue DESC
LIMIT 5;

-- 11. Users with most orders
SELECT u.name, COUNT(o.order_id) AS orders_count
FROM orders o
JOIN users u ON o.user_id = u.user_id
GROUP BY u.name
ORDER BY orders_count DESC;
