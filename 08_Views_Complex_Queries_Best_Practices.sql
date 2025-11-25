-- =====================================================
-- MYSQL LEARNING SERIES - FILE 8 (OFFICIAL & PERFECT)
-- Topic: VIEWS • Complex Reusable Queries • Production Best Practices
-- This file follows the exact same gold-standard structure as File 7
-- =====================================================

-- ===================================================================
-- THEORY SECTION 1: What are VIEWS and Why They Exist
-- ===================================================================
-- VIEW = A stored SELECT query that behaves like a virtual table

-- Real-world reasons companies use VIEWS daily:
-- → Hide complexity from juniors and BI tools
-- → Hide sensitive columns (salary, phone, passwords)
-- → Enforce consistent business logic everywhere
-- → Simplify dashboards (Power BI, Metabase, Tableau)
-- → Act as a security layer (users see only what you allow)

-- Important facts:
-- • Views do NOT store data (always fresh)
-- • Simple views can be updated
-- • Complex views (with JOIN/GROUP BY) are read-only
-- • MySQL does NOT have materialized views → use summary tables instead

-- ===================================================================
-- THEORY SECTION 2: Types of VIEWS You Will See in Jobs
-- ===================================================================
-- 1. Simple View          → From one table
-- 2. Complex View         → Multi-table + aggregations (this file)
-- 3. Security View        → Hides columns
-- 4. Reporting View       → Pre-aggregated for dashboards

-- ===================================================================
-- PHASE 1: Fresh Start – Full E-Commerce Database (Same as File 7)
-- ===================================================================

DROP DATABASE IF EXISTS mysql_learning;
CREATE DATABASE mysql_learning;
USE mysql_learning;

-- Categories
CREATE TABLE categories (
    category_id   INT PRIMARY KEY AUTO_INCREMENT,
    name          VARCHAR(50) NOT NULL UNIQUE,
    description   TEXT
);

-- Products
CREATE TABLE products (
    product_id    INT PRIMARY KEY AUTO_INCREMENT,
    name          VARCHAR(200) NOT NULL,
    price         DECIMAL(10,2) NOT NULL CHECK(price > 0),
    stock         INT DEFAULT 0,
    category_id   INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Customers
CREATE TABLE customers (
    customer_id   INT PRIMARY KEY AUTO_INCREMENT,
    name          VARCHAR(100) NOT NULL,
    email         VARCHAR(100) UNIQUE NOT NULL,
    phone         VARCHAR(15),
    city          VARCHAR(50),
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders
CREATE TABLE orders (
    order_id      INT PRIMARY KEY AUTO_INCREMENT,
    customer_id   INT NOT NULL,
    order_date    DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount  DECIMAL(12,2),
    status        VARCHAR(20) DEFAULT 'pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- Order Items (junction table)
CREATE TABLE order_items (
    order_id      INT,
    product_id    INT,
    quantity      INT NOT NULL DEFAULT 1,
    unit_price    DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id)   REFERENCES orders(order_id)   ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE RESTRICT
);

-- ===================================================================
-- PHASE 2: Insert Realistic Data
-- ===================================================================

INSERT INTO categories (name, description) VALUES
('Electronics', 'Phones, laptops, gadgets'),
('Clothing',    'Apparel and fashion'),
('Books',       'All kinds of books'),
('Home',        'Home appliances and decor');

INSERT INTO products (name, price, stock, category_id) VALUES
('iPhone 15 Pro',     129900.00, 15, 1),
('MacBook Pro M3',    229900.00,  8, 1),
('T-Shirt Cotton',       799.00, 200, 2),
('Denim Jeans',         2799.00,  80, 2),
('Atomic Habits',        499.00, 150, 3),
('Coffee Maker',        5499.00,  30, 4),
('Yoga Mat',            1899.00,  60, 2);

INSERT INTO customers (name, email, phone, city) VALUES
('Rahul Sharma',   'rahul@gmail.com',   '9876543210', 'Delhi'),
('Priya Singh',    'priya@yahoo.com',   '9876543211', 'Mumbai'),
('Aman Verma',     'aman@gmail.com',    '9876543212', 'Bangalore'),
('Sneha Kapoor',   'sneha@gmail.com',   '9876543213', 'Pune'),
('Vikram Rao',     'vikram@outlook.com',NULL,        'Hyderabad');

INSERT INTO orders (customer_id, total_amount, status) VALUES
(1, 135397.00, 'delivered'),
(2,   2799.00, 'shipped'),
(1, 131799.00, 'pending'),
(3,    499.00, 'delivered'),
(4,   5499.00, 'processing');

INSERT INTO order_items VALUES
(1,1,1,129900.00), (1,3,5,799.00),
(2,4,1,2799.00),
(3,1,1,129900.00),
(4,5,1,499.00),
(5,6,1,5499.00);

-- ===================================================================
-- PHASE 3: CREATE PROFESSIONAL VIEWS – Real Company Style
-- ===================================================================

-- VIEW 1: Customer 360° Dashboard (Marketing + CRM teams use this)
CREATE OR REPLACE VIEW v_customer_360 AS
SELECT 
    c.customer_id,
    c.name,
    c.email,
    c.city,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.total_amount), 0) AS lifetime_value,
    ROUND(AVG(o.total_amount), 2) AS avg_order_value,
    MAX(o.order_date) AS last_order_date,
    DATEDIFF(CURDATE(), MAX(o.order_date)) AS days_since_last_order
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.email, c.city;

-- VIEW 2: Live Product Catalog (Frontend + Mobile App uses this)
CREATE OR REPLACE VIEW v_product_catalog AS
SELECT 
    p.product_id,
    p.name AS product_name,
    p.price,
    p.stock,
    COALESCE(cat.name, 'Uncategorized') AS category,
    CASE 
        WHEN p.stock = 0 THEN 'Out of Stock'
        WHEN p.stock <= 10 THEN 'Low Stock'
        ELSE 'In Stock'
    END AS stock_status
FROM products p
LEFT JOIN categories cat ON p.category_id = cat.category_id;

-- VIEW 3: Daily Sales Report (CEO sees this every morning)
CREATE OR REPLACE VIEW v_daily_sales_report AS
SELECT 
    DATE(o.order_date) AS sale_date,
    COUNT(*) AS total_orders,
    SUM(o.total_amount) AS daily_revenue,
    ROUND(AVG(o.total_amount), 2) AS avg_order_value,
    COUNT(DISTINCT o.customer_id) AS unique_customers
FROM orders o
GROUP BY sale_date
ORDER BY sale_date DESC;

-- VIEW 4: Complete Order Details (Most used view in any company)
CREATE OR REPLACE VIEW v_order_details AS
SELECT 
    o.order_id,
    o.order_date,
    o.status,
    o.total_amount,
    c.name AS customer_name,
    c.email,
    c.city,
    p.name AS product_name,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) AS line_total
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;

-- Test your views
SELECT * FROM v_customer_360 ORDER BY lifetime_value DESC;
SELECT * FROM v_product_catalog WHERE stock_status = 'Low Stock';
SELECT * FROM v_daily_sales_report LIMIT 10;
SELECT * FROM v_order_details WHERE status = 'pending';

-- ===================================================================
-- PHASE 4: Complex Reusable Business Queries (Interview + Job Level)
-- ===================================================================

-- Q1: Top 10 customers by revenue
SELECT name, lifetime_value FROM v_customer_360 ORDER BY lifetime_value DESC LIMIT 10;

-- Q2: Monthly revenue trend
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(*) AS orders,
    SUM(total_amount) AS revenue
FROM orders
GROUP BY month
ORDER BY month DESC;

-- Q3: Products generating 80% of revenue (Pareto analysis)
SELECT 
    product_name,
    revenue,
    ROUND(100 * revenue / total_revenue, 2) AS percent_of_total,
    ROUND(SUM(percent_cumulative) OVER (ORDER BY revenue DESC), 2) AS running_percentage
FROM (
    SELECT 
        p.name AS product_name,
        SUM(oi.quantity * oi.unit_price) AS revenue,
        SUM(SUM(oi.quantity * oi.unit_price)) OVER () AS total_revenue,
        SUM(SUM(oi.quantity * oi.unit_price)) OVER (ORDER BY SUM(oi.quantity * oi.unit_price) DESC) AS percent_cumulative
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.product_id, p.name
) ranked
WHERE running_percentage <= 80;

-- ===================================================================
-- PRACTICE QUESTIONS – SOLVE FIRST!
-- ===================================================================

-- Q1: Create a view v_high_value_customers showing customers with lifetime_value > 100000
-- [ YOUR CODE HERE ] ----------------------------------------------------





-- Q2: Create a view v_out_of_stock showing all products with stock = 0
-- [ YOUR CODE HERE ] ----------------------------------------------------





-- Q3: Write a query using v_order_details to find total revenue per city
-- [ YOUR CODE HERE ] ----------------------------------------------------





-- Q4: Create a view v_monthly_growth showing month and % growth from previous month
-- [ YOUR CODE HERE ] ----------------------------------------------------





-- ===================================================================
-- SOLUTIONS (Only after you try!)
-- ===================================================================

-- Q1
CREATE OR REPLACE VIEW v_high_value_customers AS
SELECT * FROM v_customer_360 WHERE lifetime_value > 100000;

-- Q2
CREATE OR REPLACE VIEW v_out_of_stock AS
SELECT * FROM v_product_catalog WHERE stock_status = 'Out of Stock';

-- Q3
SELECT city, SUM(line_total) AS city_revenue
FROM v_order_details
GROUP BY city
ORDER BY city_revenue DESC;

-- Q4
CREATE OR REPLACE VIEW v_monthly_growth AS
WITH monthly AS (
    SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(total_amount) AS revenue
    FROM orders GROUP BY month
)
SELECT 
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS prev_month,
    ROUND(COALESCE((revenue - LAG(revenue) OVER (ORDER BY month))/LAG(revenue) OVER (ORDER BY month)*100, 0), 2) AS growth_pct
FROM monthly;

-- ===================================================================
-- END OF FILE 8 – YOU ARE NOW A PROFESSIONAL
-- You have mastered:
-- • Creating production-grade VIEWS
-- • Complex reusable business queries
-- • Real-world best practices used by senior developers
-- • Security and abstraction patterns

-- Next → File 9: INDEXES • TRANSACTIONS • WINDOW FUNCTIONS • CTEs • EXPLAIN
-- Say "File 9" when you're ready – this is where you become senior-level
-- ===================================================================