-- =====================================================
-- MYSQL LEARNING SERIES - FILE 7 (IN-DEPTH MASTERCLASS)
-- Topic: Relationships • Foreign Keys • All JOIN Types • Real-World Patterns
-- This is the MOST IMPORTANT file in the entire course
-- =====================================================

-- ===================================================================
-- THEORY SECTION 1: Why Relationships Exist
-- ===================================================================
-- Real world is connected:
-- → One Customer has Many Orders
-- → One Product belongs to One Category
-- → One Teacher teaches Many Students
-- → One Post has Many Comments

-- Without relationships → duplicate data, chaos
-- With relationships → clean, fast, accurate database

-- 3 Types of Relationships:
-- 1. One-to-One     (rare)  → user → profile
-- 2. One-to-Many    (most common) → customer → orders
-- 3. Many-to-Many   (requires junction table) → students ↔ courses

-- ===================================================================
-- THEORY SECTION 2: Foreign Key – The Glue of Relationships
-- ===================================================================
-- FOREIGN KEY = column that refers to PRIMARY KEY of another table
-- Rules:
-- • Value must exist in parent table (referential integrity)
-- • Prevents orphan records
-- • Enables fast JOINs

-- ===================================================================
-- PHASE 1: Fresh Start – Build a Real E-Commerce Database
-- ===================================================================

DROP DATABASE IF EXISTS mysql_learning;
CREATE DATABASE mysql_learning;
USE mysql_learning;

-- Table 1: Categories (Parent)
CREATE TABLE categories (
    category_id   INT PRIMARY KEY AUTO_INCREMENT,
    name          VARCHAR(50) NOT NULL UNIQUE,
    description   TEXT
);

-- Table 2: Products (Child of categories)
CREATE TABLE products (
    product_id    INT PRIMARY KEY AUTO_INCREMENT,
    name          VARCHAR(100) NOT NULL,
    price         DECIMAL(10,2) NOT NULL,
    stock         INT DEFAULT 0,
    category_id   INT,
    -- FOREIGN KEY + ON DELETE/UPDATE behavior
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
        ON DELETE SET NULL      -- if category deleted → product loses category
        ON UPDATE CASCADE       -- if category_id changes (rare), update automatically , here CASCADE means if category_id in categories table is updated then it will be updated in products table as well
);

-- Table 3: Customers
CREATE TABLE customers (
    customer_id   INT PRIMARY KEY AUTO_INCREMENT,
    name          VARCHAR(100) NOT NULL,
    email         VARCHAR(100) UNIQUE NOT NULL,
    phone         VARCHAR(15),
    city          VARCHAR(50),
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table 4: Orders (Child of customers)
CREATE TABLE orders (
    order_id      INT PRIMARY KEY AUTO_INCREMENT,
    customer_id   INT NOT NULL,
    order_date    DATE DEFAULT (CURRENT_DATE),
    total_amount  DECIMAL(12,2),
    status        VARCHAR(20) DEFAULT 'pending',
    
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE RESTRICT      -- cannot delete customer if they have orders
        ON UPDATE CASCADE
);

-- Table 5: Order Items (Many-to-Many bridge: orders ↔ products)
CREATE TABLE order_items (
    order_id      INT,
    product_id    INT,
    quantity      INT NOT NULL DEFAULT 1,
    unit_price    DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (order_id, product_id),  -- Composite key
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE RESTRICT
);

-- ===================================================================
-- PHASE 2: Insert Realistic Data
-- ===================================================================

INSERT INTO categories (name, description) VALUES
('Electronics', 'Phones, laptops, gadgets'),
('Clothing', 'Shirts, jeans, dresses'),
('Books', 'Fiction, non-fiction, textbooks'),
('Home', 'Furniture, decor, appliances');

INSERT INTO products (name, price, stock, category_id) VALUES
('iPhone 15 Pro', 129900.00, 15, 1),
('MacBook Air M3', 124900.00, 8, 1),
('Cotton T-Shirt', 799.00, 100, 2),
('Slim Fit Jeans', 2199.00, 50, 2),
('Atomic Habits', 499.00, 200, 3),
('Coffee Maker', 5499.00, 30, 4),
('Yoga Mat', 1299.00, 80, 2);

INSERT INTO customers (name, email, phone, city) VALUES
('Rahul Sharma', 'rahul@gmail.com', '9876543210', 'Delhi'),
('Priya Singh', 'priya@yahoo.com', '9876543211', 'Mumbai'),
('Aman Verma', 'aman@hotmail.com', '9876543212', 'Bangalore'),
('Sneha Kapoor', 'sneha@gmail.com', '9876543213', 'Pune');

INSERT INTO orders (customer_id, total_amount, status) VALUES
(1, 135398.00, 'delivered'),
(2, 2199.00, 'shipped'),
(3, 129900.00, 'pending'),
(1, 998.00, 'delivered');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 129900.00),  -- Rahul bought iPhone
(1, 3, 5, 799.00),      -- + 5 T-shirts
(2, 4, 1, 2199.00),     -- Priya bought jeans
(3, 1, 1, 129900.00),   -- Aman bought iPhone
(4, 5, 2, 499.00);      -- Rahul bought 2 books

-- ===================================================================
-- PHASE 3: All Types of JOINs – Complete Mastery
-- ===================================================================

-- 1. CROSS JOIN (Cartesian Product) – rarely used directly
SELECT c.name, p.name 
FROM customers c 
CROSS JOIN products p 
LIMIT 10;

-- 2. INNER JOIN (Most Common) – only matching rows
SELECT 
    o.order_id,
    c.name AS customer,
    o.total_amount,
    o.status
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;

-- 3. LEFT JOIN (All from left table + matching from right)
SELECT 
    c.name AS customer,
    o.order_id,
    o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;
-- → Shows customers with NO orders too!

-- 4. RIGHT JOIN (All from right table + matching from left)
SELECT 
    c.name,
    o.order_id
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;
-- → Rare, but useful sometimes

-- 5. FULL OUTER JOIN → MySQL doesn't support directly → use UNION
SELECT c.name, o.order_id FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id
UNION
SELECT c.name, o.order_id FROM customers c RIGHT JOIN orders o ON c.customer_id = o.customer_id;

-- ===================================================================
-- PHASE 4: Real-World JOIN Queries (Interview Level)
-- ===================================================================

-- Q1: Show order details with customer name and product names
SELECT 
    o.order_id,
    c.name AS customer,
    p.name AS product,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) AS line_total
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_id;

-- Q2: Top 5 most sold products
SELECT 
    p.name,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.name
ORDER BY units_sold DESC
LIMIT 5;

-- Q3: Customers who never placed an order
SELECT 
    c.name,
    c.email
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Q4: Revenue by category
SELECT 
    c.name AS category,
    COUNT(oi.product_id) AS items_sold,
    SUM(oi.quantity * oi.unit_price) AS category_revenue
FROM categories c
JOIN products p ON c.category_id = p.category_id
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY c.category_id, c.name
ORDER BY category_revenue DESC;

-- ===================================================================
-- PRACTICE QUESTIONS – SOLVE FIRST!
-- ===================================================================

-- Q1: List all products with their category name (use LEFT JOIN)
-- [ YOUR CODE HERE ] ----------------------------------------------------





-- Q2: Show all orders with customer name and city (even if city is NULL)
-- [ YOUR CODE HERE ] ----------------------------------------------------





-- Q3: Find products that have NEVER been ordered
-- [ YOUR CODE HERE ] ----------------------------------------------------






-- Q4: Show customer name and total number of orders they placed
-- [ YOUR CODE HERE ] ----------------------------------------------------






-- Q5: Revenue generated by each city
-- [ YOUR CODE HERE ] ----------------------------------------------------






-- ===================================================================
-- SOLUTIONS (Only after you solve!)
-- ===================================================================

-- Q1
SELECT p.name, c.name AS category_name 
FROM products p 
LEFT JOIN categories c ON p.category_id = c.category_id;

-- Q2
SELECT o.order_id, c.name, c.city 
FROM orders o 
JOIN customers c ON o.customer_id = c.customer_id;

-- Q3
SELECT p.name 
FROM products p 
LEFT JOIN order_items oi ON p.product_id = oi.product_id 
WHERE oi.product_id IS NULL;

-- Q4
SELECT c.name, COUNT(o.order_id) AS total_orders 
FROM customers c 
LEFT JOIN orders o ON c.customer_id = o.customer_id 
GROUP BY c.customer_id, c.name;

-- Q5
SELECT c.city, SUM(oi.quantity * oi.unit_price) AS city_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.city
ORDER BY city_revenue DESC;

-- ===================================================================
-- END OF FILE 7 – YOU ARE NOW A SQL PROFESSIONAL
-- You have mastered:
-- • One-to-Many & Many-to-Many relationships
-- • Foreign Keys with proper ON DELETE/UPDATE
-- • All JOIN types with real meaning
-- • Complex multi-table business queries
-- • Database design that scales to millions of rows

-- Next → File 8: Views + Final Mastery
-- Say "File 8" when you're ready – you’ve earned it!
-- ===================================================================