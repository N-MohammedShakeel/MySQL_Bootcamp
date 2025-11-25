-- =====================================================
-- MYSQL LEARNING SERIES - FILE 4
-- Topic: WHERE Clause Mastery + 100% Safe UPDATE & DELETE
-- Goal: Never accidentally destroy data again
-- =====================================================

-- ===================================================================
-- THEORY SECTION 1: The WHERE Clause – The Most Important Clause
-- ===================================================================
-- WHERE decides WHICH rows are affected by SELECT, UPDATE, DELETE
-- Without WHERE → the command runs on the ENTIRE table → Disaster!

-- Logical execution order (FWSOL):
-- 1. FROM → 2. WHERE → 3. SELECT → 4. ORDER BY → 5. LIMIT
-- WHERE runs second — very early — so it protects you

-- ===================================================================
-- THEORY SECTION 2: DELETE vs TRUNCATE vs DROP (Never confuse again)
-- ===================================================================
-- DELETE FROM table;          → Removes rows one by one, can use WHERE, slow
-- DELETE FROM table WHERE id=5; → Safe, only one row

-- TRUNCATE TABLE table;       → Instantly removes ALL rows, resets AUTO_INCREMENT
--                              Cannot use WHERE → always deletes everything

-- DROP TABLE table;           → Deletes table + structure completely
-- DROP DATABASE name;         → Deletes entire database

-- ===================================================================
-- PHASE 1: Fresh Start with Realistic Data
-- ===================================================================

DROP DATABASE IF EXISTS mysql_learning;
CREATE DATABASE mysql_learning;
USE mysql_learning;

-- Realistic e-commerce orders table
CREATE TABLE orders (
    order_id      INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(50) NOT NULL,
    product       VARCHAR(100) NOT NULL,
    amount        DECIMAL(10,2) NOT NULL,
    status        VARCHAR(20) DEFAULT 'pending', -- pending, shipped, delivered, cancelled
    city          VARCHAR(50),
    order_date    DATE DEFAULT (CURRENT_DATE)
);

-- Insert 25+ realistic orders
INSERT INTO orders (customer_name, product, amount, status, city) VALUES
('Rahul Sharma',    'iPhone 15 Pro',      99999.00, 'delivered',  'Delhi'),
('Priya Singh',     'MacBook Air',       109900.00, 'shipped',    'Mumbai'),
('Aman Verma',      'T-Shirt',             799.00, 'pending',    'Bangalore'),
('Sneha Kapoor',    'Wireless Earbuds',   8999.00, 'delivered',  'Pune'),
('Vikram Rao',      'Smart Watch',       24999.00, 'cancelled',  'Hyderabad'),
('Neha Gupta',      'Jeans',              1899.00, 'pending',    'Gurugram'),
('Rohan Das',       'Laptop Stand',       1299.00, 'shipped',    'Chennai'),
('Anjali Reddy',    'Coffee Mug',          349.00, 'delivered',  'Kochi'),
('Karan Mehta',     'Gaming Mouse',       4599.00, 'pending',    'Jaipur'),
('Pooja Desai',     'Water Bottle',        599.00, 'pending',    'Surat'),
('Arjun Patel',     'USB-C Cable',         799.00, 'delivered',  'Ahmedabad'),
('Sunita Yadav',    'Phone Case',          699.00, 'cancelled',  'Lucknow'),
('Rajesh Kumar',    'Bluetooth Speaker',  5999.00, 'shipped',    'Patna'),
('Meera Nair',      'Desk Lamp',          2199.00, 'pending',    'Thiruvananthapuram'),
('Deepak Joshi',    'Keyboard',          3499.00, 'delivered',  'Indore');

SELECT * FROM orders;

-- ===================================================================
-- PHASE 2: WHERE Clause – Every Possible Pattern (Master This!)
-- ===================================================================

-- Basic comparisons
SELECT * FROM orders WHERE amount > 10000;
SELECT * FROM orders WHERE status = 'pending';
SELECT * FROM orders WHERE city = 'Delhi';

-- Multiple conditions
SELECT * FROM orders WHERE amount > 5000 AND status = 'pending';
SELECT * FROM orders WHERE status = 'delivered' OR status = 'shipped';
SELECT * FROM orders WHERE amount >= 1000 AND amount <= 10000;

-- IN, NOT IN
SELECT * FROM orders WHERE city IN ('Delhi', 'Mumbai', 'Pune');
SELECT * FROM orders WHERE status NOT IN ('delivered', 'cancelled');

-- LIKE (pattern matching)
SELECT * FROM orders WHERE customer_name LIKE 'R%';        -- starts with R
SELECT * FROM orders WHERE customer_name LIKE '%Singh%';   -- contains Singh
SELECT * FROM orders WHERE product LIKE '%phone%';        -- contains "phone" (case insensitive in most cases)

-- NULL checking
SELECT * FROM orders WHERE city IS NULL;
SELECT * FROM orders WHERE city IS NOT NULL;

-- Combining everything
SELECT * FROM orders 
WHERE (status = 'pending' OR status = 'shipped')
  AND amount > 3000
  AND customer_name LIKE 'A%';

-- ===================================================================
-- PHASE 3: UPDATE – Safe vs Dangerous
-- ===================================================================

-- NEVER DO THIS (updates every row!)
-- UPDATE orders SET status = 'delivered';

-- SAFE UPDATES (always use WHERE!)
UPDATE orders SET status = 'shipped' WHERE order_id = 3;        -- only one pending
UPDATE orders SET amount = amount * 0.9 WHERE status = 'cancelled'; -- 10% refund
UPDATE orders SET city = 'New Delhi' WHERE city = 'Delhi';

-- Bulk safe update
UPDATE orders SET status = 'delivered' WHERE amount > 50000;

SELECT * FROM orders;

-- ===================================================================
-- PHASE 4: DELETE – Safe vs Dangerous
-- ===================================================================

-- NEVER DO THIS
-- DELETE FROM orders;

-- SAFE DELETES
DELETE FROM orders WHERE status = 'cancelled';                    -- remove cancelled
DELETE FROM orders WHERE amount < 500;                            -- remove very small
DELETE FROM orders WHERE order_id = 10;                           -- specific order

-- TRUNCATE vs DELETE demo (run one at a time)
-- TRUNCATE TABLE orders;        -- removes ALL rows instantly, resets id to 1
-- DELETE FROM orders;           -- removes all but slower, doesn't reset id

SELECT * FROM orders;

-- ===================================================================
-- PRACTICE QUESTIONS (Solve → then check solutions)
-- ===================================================================

-- QUESTION 1: Find all pending orders above 2000
-- [ YOUR CODE HERE ] ----------------------------------------------------






-- QUESTION 2: Mark all orders from Mumbai as "shipped"
-- [ YOUR CODE HERE ] ----------------------------------------------------






-- QUESTION 3: Give 15% discount to all pending orders above 5000
-- [ YOUR CODE HERE ] ----------------------------------------------------






-- QUESTION 4: Delete all delivered orders below 1000 (junk orders)
-- [ YOUR CODE HERE ] ----------------------------------------------------






-- QUESTION 5: Delete all orders containing "Mug" or "Bottle" in product name
-- [ YOUR CODE HERE ] ----------------------------------------------------






-- ===================================================================
-- SOLUTIONS (Check only after trying!)
-- ===================================================================

-- SOLUTION 1
SELECT * FROM orders WHERE status = 'pending' AND amount > 2000;

-- SOLUTION 2
UPDATE orders SET status = 'shipped' WHERE city = 'Mumbai';

-- SOLUTION 3
UPDATE orders SET amount = amount * 0.85 
WHERE status = 'pending' AND amount > 5000;

-- SOLUTION 4
DELETE FROM orders WHERE status = 'delivered' AND amount < 1000;

-- SOLUTION 5
DELETE FROM orders WHERE product LIKE '%Mug%' OR product LIKE '%Bottle%';

-- Final result
SELECT * FROM orders ORDER BY order_id ;

-- ===================================================================
-- END OF FILE 4
-- You have mastered:
-- • Every WHERE pattern used in real projects
-- • The difference between safe and dangerous UPDATE/DELETE
-- • TRUNCATE vs DROP vs DELETE forever
-- • Never accidentally destroy data again

-- Next → File 5: Functions, ORDER BY, LIMIT, Aggregation, GROUP BY (Get ready for complex reports!)
-- ===================================================================