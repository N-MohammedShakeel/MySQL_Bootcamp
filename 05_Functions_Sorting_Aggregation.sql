-- =====================================================
-- MYSQL LEARNING SERIES - FILE 5 
-- Topic: Functions • ORDER BY • LIMIT • LIKE • Aggregate • GROUP BY • HAVING
-- Includes: Execution Order + Monster Query + Deep GROUP BY/HAVING Theory
-- =====================================================

-- ===================================================================
-- THEORY SECTION: GROUP BY & HAVING – DEEP DIVE (MOST IMPORTANT!)
-- ===================================================================

-- GROUP BY → Splits data into groups based on one or more columns
-- Aggregate functions (COUNT, SUM, AVG...) are calculated PER group

-- HAVING → Acts like WHERE, but for GROUPS
-- WHERE filters rows BEFORE grouping
-- HAVING filters groups AFTER grouping

-- Memory Trick:
-- WHERE → Filters individual rows (early)
-- HAVING → Filters groups (late)

-- Example:
-- WHERE amount > 1000     → removes cheap sales before grouping
-- HAVING SUM(amount) > 50000 → removes customers who didn't spend enough

-- ===================================================================
-- EXECUTION ORDER 1: Only GROUP BY + HAVING (Simple Flow)
-- ===================================================================

-- 1. FROM sales
-- 2. WHERE (filters rows)
-- 3. GROUP BY category         ← creates groups
-- 4. HAVING COUNT(*) > 5       ← filters groups
-- 5. SELECT category, SUM(amount)

-- ===================================================================
-- EXECUTION ORDER 2: FULL QUERY (Everything Learned Till Now)
-- ===================================================================

-- MySQL executes in THIS exact order (NOT the order you write!):

-- 1. FROM
-- 2. WHERE
-- 3. GROUP BY
-- 4. HAVING
-- 5. SELECT (including functions, aliases)
-- 6. ORDER BY
-- 7. LIMIT / OFFSET

-- Memory Trick: F → W → G → H → S → O → L  
-- (From → Where → Group → Having → Select → Order → Limit)

-- ===================================================================
-- PHASE 1: Fresh Start + Data
-- ===================================================================

DROP DATABASE IF EXISTS mysql_learning;
CREATE DATABASE mysql_learning;
USE mysql_learning;

CREATE TABLE sales (
    sale_id       INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(50),
    product       VARCHAR(100),
    category      VARCHAR(30),
    amount        DECIMAL(10,2),
    city          VARCHAR(50),
    sale_date     DATE,
    quantity      INT DEFAULT 1
);

INSERT INTO sales (customer_name, product, category, amount, city, sale_date, quantity) VALUES
('Rahul', 'iPhone 15', 'Electronics', 99900.00, 'Delhi', '2025-01-15', 1),
('Priya', 'T-Shirt', 'Clothing', 799.00, 'Mumbai', '2025-01-16', 3),
('Aman', 'MacBook Pro', 'Electronics', 189000.00, 'Bangalore', '2025-01-17', 1),
('Sneha', 'Jeans', 'Clothing', 2499.00, 'Pune', '2025-01-18', 2),
('Vikram', 'Smart Watch', 'Electronics', 29999.00, 'Hyderabad', '2025-01-19', 1),
('Neha', 'Coffee Maker', 'Home', 5499.00, 'Gurugram', '2025-01-20', 1),
('Rohan', 'Running Shoes', 'Sports', 4599.00, 'Chennai', '2025-01-21', 1),
('Anjali', 'Yoga Mat', 'Sports', 1299.00, 'Kolkata', '2025-01-22', 2),
('Karan', 'Bluetooth Speaker','Electronics', 7999.00, 'Jaipur', '2025-01-23', 1),
('Pooja', 'Water Bottle', 'Sports', 599.00, 'Surat', '2025-01-24', 5),
('Arjun', 'Laptop Stand', 'Electronics', 1899.00, 'Ahmedabad', '2025-02-01', 1),
('Sunita', 'Desk Lamp', 'Home', 2199.00, 'Lucknow', '2025-02-02', 1),
('Rajesh', 'Wireless Mouse', 'Electronics', 899.00, 'Patna', '2025-02-03', 2),
('Meera', 'Keyboard', 'Electronics', 3499.00, 'Kochi', '2025-02-04', 1),
('Deepak', 'Headphones', 'Electronics', 15999.00, 'Indore', '2025-02-05', 1),
('Rahul', 'T-Shirt', 'Clothing', 799.00, 'Delhi', '2025-02-10', 4),
('Priya', 'iPhone Case', 'Electronics', 999.00, 'Mumbai', '2025-02-11', 1);

-- ===================================================================
-- PHASE 2: Functions Demo (100% Professional)
-- ===================================================================

SELECT 
    customer_name,
    UPPER(customer_name) AS name_upper,
    LOWER(product) AS product_lower,
    CONCAT(customer_name, ' bought ', product) AS purchase_story,
    LENGTH(product) AS product_name_length,
    ROUND(amount) AS amount_rounded,
    ROUND(amount, 2) AS amount_with_cents,
    CURDATE() AS current_date_only,
    NOW() AS query_executed_at, 
    DATE_FORMAT(sale_date, '%d-%m-%Y') AS sale_date_indian,
    DATE_FORMAT(sale_date, '%W, %d %M %Y') AS sale_date_full
FROM sales;

-- ===================================================================
-- PHASE 3: ORDER BY + LIMIT + Pagination
-- ===================================================================

SELECT * FROM sales ORDER BY amount DESC LIMIT 5;
SELECT * FROM sales ORDER BY sale_id LIMIT 5 OFFSET 5;  -- Page 2

-- ===================================================================
-- MONSTER QUERY: Uses EVERY Keyword Learned So Far!
-- ===================================================================

SELECT 
    city,
    COUNT(*) AS total_orders,
    SUM(amount) AS city_revenue,
    ROUND(AVG(amount), 2) AS avg_order_value,
    MAX(amount) AS highest_sale,
    CONCAT('₹', FORMAT(SUM(amount), 0)) AS revenue_formatted
FROM sales 
WHERE sale_date >= '2025-01-01'
  AND product NOT LIKE '%Case%'
  AND amount > 500
GROUP BY city
HAVING SUM(amount) > 20000
ORDER BY city_revenue DESC
LIMIT 5;

-- ===================================================================
-- PRACTICE QUESTIONS – WRITE YOUR ANSWERS FIRST!
-- ===================================================================

-- Q1: Show top 10 most expensive sales with customer name, product, amount 
--     and sale date formatted as "15 Jan 2025"

-- [ YOUR CODE HERE ] ----------------------------------------------------






-- Q2: Show monthly total revenue for 2025 (January, February...) 
--     with column name "month" and "revenue"

-- [ YOUR CODE HERE ] ----------------------------------------------------






-- Q3: Find cities that have more than 2 sales AND average sale amount > 5000

-- [ YOUR CODE HERE ] ----------------------------------------------------






-- Q4: Show all products that contain the word "phone" (case insensitive)

-- [ YOUR CODE HERE ] ----------------------------------------------------






-- Q5: Who are the top 3 customers by total spending? Show name and total

-- [ YOUR CODE HERE ] ----------------------------------------------------






-- ===================================================================
-- SOLUTIONS (Only look after you have tried!)
-- ===================================================================

-- Q1
SELECT 
    customer_name, 
    product, 
    amount, 
    DATE_FORMAT(sale_date, '%d %b %Y') AS sale_date 
FROM sales 
ORDER BY amount DESC 
LIMIT 10;

-- Q2
SELECT 
    DATE_FORMAT(sale_date, '%Y-%m') AS month,
    SUM(amount) AS revenue
FROM sales 
GROUP BY month 
ORDER BY month;

-- Q3
SELECT 
    city, 
    COUNT(*) AS sales_count,
    AVG(amount) AS avg_amount
FROM sales 
GROUP BY city 
HAVING COUNT(*) > 2 AND AVG(amount) > 5000;

-- Q4
SELECT * FROM sales 
WHERE product LIKE '%phone%' OR product LIKE '%Phone%';

-- Q5
SELECT 
    customer_name,
    SUM(amount) AS total_spent
FROM sales 
GROUP BY customer_name 
ORDER BY total_spent DESC 
LIMIT 3;

-- ===================================================================
-- END OF FILE 5 – YOU ARE NOW A MYSQL BEAST
-- You have mastered:
-- • Full logical execution order (F-W-G-H-S-O-L)
-- • GROUP BY vs HAVING crystal clear
-- • Real-world reporting queries
-- • Professional formatting and functions
--
-- Next → File 6: CASE Statement • UNIQUE • CHECK • ALTER TABLE
-- Just say "File 6" when you're ready!
-- ===================================================================