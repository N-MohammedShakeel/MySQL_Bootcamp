-- =====================================================
-- MYSQL LEARNING SERIES
-- File 2: Full Theory → Data Types → Constraints → ALL OPERATORS
-- =====================================================

-- ===================================================================
-- THEORY SECTION 1: Why Data Types & Constraints Exist
-- ===================================================================
-- Data Type   → Defines what kind of value can go inside a column
-- Constraint  → Rule that protects data quality and prevents garbage

-- ===================================================================
-- THEORY SECTION 2: ALL MYSQL DATA TYPES (With Real-Life Use Cases)
-- ===================================================================

-- NUMERIC
-- TINYINT      →  -128 to 127                  → status flags (0/1), gender, yes/no
-- SMALLINT     →  -32k to 32k                  → small counts
-- INT          →  -2B to 2B                    → IDs, quantities (most used)
-- BIGINT       →  very large numbers           → bank transaction IDs
-- DECIMAL(10,2)→  exact decimal (money)        → price, salary → NEVER use FLOAT
-- FLOAT/DOUBLE → approximate decimals          → scientific calculations only

-- STRING / TEXT
-- CHAR(5)      → fixed length (always 5 chars) → country code: IN, US, UK
-- VARCHAR(255) → variable up to 255 chars      → name, email, city (most common)
-- TEXT         → up to 65KB                    → blog post, description
-- MEDIUMTEXT   → up to 16MB
-- LONGTEXT     → up to 4GB                     → books, logs

-- DATE & TIME
-- DATE         → '2025-11-25'
-- TIME         → '09:30:00'
-- DATETIME     → '2025-11-25 09:30:00'         → most common
-- TIMESTAMP    → auto timezone aware          → created_at, updated_at
-- YEAR         → '2025'

-- BOOLEAN → MySQL has no real BOOLEAN → use TINYINT(1) → 0 = false, 1 = true

-- ===================================================================
-- THEORY SECTION 3: ALL 6 IMPORTANT CONSTRAINTS
-- ===================================================================

-- 1. NOT NULL         → value is compulsory
-- 2. UNIQUE           → no duplicates allowed in this column
-- 3. PRIMARY KEY      → UNIQUE + NOT NULL + used to identify each row uniquely
-- 4. AUTO_INCREMENT   → automatically increases by 1 (used only with INT PK)
-- 5. DEFAULT          → auto-fill value if you don't provide one
-- 6. CHECK            → custom logical condition

-- ===================================================================
-- THEORY SECTION 4: ALL OPERATORS YOU MUST KNOW (With Examples)
-- ===================================================================

-- COMPARISON OPERATORS
-- =          → equal to
-- !=  or <>  → not equal to
-- > , < , >= , <= → obvious

-- LOGICAL OPERATORS
-- AND        → both conditions must be true
-- OR         → any one condition true
-- NOT        → reverse the condition

-- SPECIAL OPERATORS (Very Important in Interviews)
-- IN         → checks if value is in a list
--             Example: WHERE city IN ('Delhi', 'Mumbai', 'Pune')

-- BETWEEN    → checks range (inclusive)
--             Example: WHERE age BETWEEN 18 AND 30   → 18 and 30 included

-- LIKE       → pattern matching with wildcards
--             %  → any number of characters
--             _  → exactly one character
--             Example: WHERE name LIKE 'A%'      → starts with A
--                      WHERE name LIKE '%ing'    → ends with ing
--                      WHERE phone LIKE '98________' → 10-digit starting with 98

-- IS NULL / IS NOT NULL → check for empty values
--             WHERE phone IS NULL
--             WHERE email IS NOT NULL

-- ===================================================================
-- PHASE 1: Fresh Start
-- ===================================================================

DROP DATABASE IF EXISTS mysql_learning;
CREATE DATABASE mysql_learning;
USE mysql_learning;

-- ===================================================================
-- PHASE 2: Ultimate Table Using Everything Above
-- ===================================================================

CREATE TABLE employees (
    id          INT PRIMARY KEY AUTO_INCREMENT,   -- Unique employee ID , auto increments
    emp_code    CHAR(6) UNIQUE NOT NULL,          -- Unique employee code , must provide value
    name        VARCHAR(50) NOT NULL,             -- Employee name , must provide value
    email       VARCHAR(100) UNIQUE NOT NULL,     -- Unique email , must provide value
    phone       VARCHAR(15) UNIQUE,               -- Unique phone number , can be NULL
    salary      DECIMAL(10,2) NOT NULL DEFAULT 30000.00,  -- Salary with default
    age         TINYINT CHECK (age BETWEEN 18 AND 60),    -- Age with CHECK constraint
    gender      CHAR(1) CHECK (gender IN ('M','F','O')),  -- only M, F, O allowed
    city        VARCHAR(50) CHECK (city IN ('Delhi','Mumbai','Bangalore','Pune','Hyderabad')), -- limited cities
    is_active   TINYINT(1) DEFAULT 1,                    -- 1 = active
    join_date   DATE DEFAULT (CURRENT_DATE),             -- date of joining
    notes       TEXT,                                    -- additional notes
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,     -- record creation time
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- record update time , here ON UPDATE CURRENT_TIMESTAMP ensures this field is updated automatically whenever the row is modified
);

DESC employees;

-- ===================================================================
-- PHASE 3: Insert Valid Data (See constraints & defaults working)
-- ===================================================================

INSERT INTO employees (emp_code, name, email, phone, salary, age, gender, city) VALUES
('E001', 'Rahul Sharma',   'rahul@company.com',   '9876543210', 75000.00, 29, 'M', 'Delhi'),
('E002', 'Priya Singh',    'priya@company.com',   '9876543211', 68000.00, 26, 'F', 'Mumbai'),
('E003', 'Aman Verma',     'aman@company.com',    NULL,         52000.00, 32, 'M', 'Bangalore'),
('E004', 'Sneha Kapoor',   'sneha@company.com',   '9876543213', 89000.00, 35, 'F', 'Pune'),
('E005', 'Vikram Rao',     'vikram@company.com',  '9876543214', 61000.00, 28, 'M', 'Hyderabad');

-- This will work → uses defaults
INSERT INTO employees (emp_code, name, email, city) 
VALUES ('E006', 'Rohan Das', 'rohan@company.com', 'Delhi'); -- this works , because other fields have defaults or can be NULL

SELECT * FROM employees;

-- ===================================================================
-- PHASE 4: Demo of All Operators
-- ===================================================================

-- = operator
SELECT * FROM employees WHERE city = 'Delhi';

-- IN operator
SELECT * FROM employees WHERE city IN ('Delhi', 'Mumbai', 'Pune');

-- BETWEEN operator
SELECT * FROM employees WHERE salary BETWEEN 60000 AND 80000;

-- LIKE operator
SELECT * FROM employees WHERE name LIKE 'R%';        -- starts with R
SELECT * FROM employees WHERE name LIKE '%Singh%';   -- contains Singh
SELECT * FROM employees WHERE phone LIKE '98________'; -- 10-digit Indian number

-- IS NULL operator
SELECT * FROM employees WHERE phone IS NULL;

-- COMBINATION with AND, OR, NOT
SELECT * FROM employees 
WHERE salary > 70000 
  AND (city = 'Delhi' OR city = 'Mumbai')
  AND gender != 'F';

-- ===================================================================
-- PRACTICE QUESTIONS (Solve first → then check solutions)
-- ===================================================================

-- QUESTION 1: Create table "products" with proper types & constraints
-- Columns:
-- product_id (INT PK AI), name (VARCHAR NOT NULL), price (DECIMAL 10,2),
-- category (must be: Electronics, Clothing, Books, Home),
-- stock (INT >= 0), is_available (TINYINT 1 default 1), added_date (DATE default today)

-- [ YOUR CODE HERE ] ----------------------------------------------------






-- QUESTION 2: Insert 8 products (mix categories and prices)

-- [ YOUR CODE HERE ] ----------------------------------------------------






-- QUESTION 3: Use operators to answer these:
-- a) All Electronics products priced between 5000 and 50000
-- b) Products whose name contains "phone" (case insensitive in real life, but here case sensitive)
-- c) All products that are NOT in Books category
-- d) Products with stock = 0

-- [ YOUR CODE HERE ] ----------------------------------------------------






-- ===================================================================
-- SOLUTIONS (Only after you attempt!)
-- ===================================================================

-- SOLUTION 1
CREATE TABLE products (
    product_id    INT PRIMARY KEY AUTO_INCREMENT,
    name          VARCHAR(100) NOT NULL,
    price         DECIMAL(10,2) NOT NULL,
    category      VARCHAR(20) CHECK (category IN ('Electronics','Clothing','Books','Home')),
    stock         INT CHECK (stock >= 0) DEFAULT 0,
    is_available  TINYINT(1) DEFAULT 1,
    added_date    DATE DEFAULT (CURRENT_DATE)
);

-- SOLUTION 2
INSERT INTO products (name, price, category, stock) VALUES
('iPhone 15',      79999.00, 'Electronics', 15),
('Cotton Shirt',    1299.00, 'Clothing',    50),
('Rich Dad',         420.00, 'Books',       100),
('LED TV 55"',     45999.00, 'Electronics', 8),
('Wireless Mouse',   899.00, 'Electronics', 0),
('Yoga Mat',        1499.00, 'Home',        30),
('Atomic Habits',    549.00, 'Books',       75),
('Jeans',           2199.00, 'Clothing',    40);

-- SOLUTION 3
-- a)
SELECT * FROM products WHERE category = 'Electronics' AND price BETWEEN 5000 AND 50000;

-- b)
SELECT * FROM products WHERE name LIKE '%phone%' OR name LIKE '%Phone%';

-- c)
SELECT * FROM products WHERE category != 'Books';
-- OR
SELECT * FROM products WHERE category NOT IN ('Books');

-- d)
SELECT * FROM products WHERE stock = 0;

SELECT * FROM products;

-- ===================================================================
-- END OF FILE 2
-- You have now mastered:
-- • Every MySQL data type with real use case
-- • All 6 constraints
-- • Every important operator (IN, BETWEEN, LIKE, IS NULL, AND/OR/NOT)
-- • Writing production-ready tables from Day 1
--
-- Next → File 3: Primary Keys Deep Dive + WHERE Clause Mastery + Safe UPDATE/DELETE
-- ===================================================================