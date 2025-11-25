-- =====================================================
-- MYSQL LEARNING SERIES - FILE 3
-- Topic: INSERT + SELECT + PRIMARY KEY + AUTO_INCREMENT
-- =====================================================

-- ===================================================================
-- THEORY SECTION 1: PRIMARY KEY – THE SOUL OF EVERY TABLE
-- ===================================================================

-- Primary Key = One column that uniquely identifies every row
-- Real-world analogy → Roll number in school, Aadhaar number

-- Rules:
-- 1. Must be UNIQUE
-- 2. Cannot be NULL
-- 3. Only ONE primary key per table
-- 4. Used later for relationships (File 7)

-- Two types:
-- • Natural Key  → Real data like email/phone (avoid)
-- • Surrogate Key → Meaningless number → BEST & RECOMMENDED

-- AUTO_INCREMENT → Automatically gives 1, 2, 3, 4... when you insert
-- Works only with INT + PRIMARY KEY

-- ===================================================================
-- THEORY SECTION 2: INSERT – All Safe & Common Ways
-- ===================================================================

-- 1. Recommended way (always specify columns)
--    INSERT INTO table (col1, col2) VALUES (val1, val2);

-- 2. Multiple rows at once (fastest)
--    INSERT INTO table (col1, col2) VALUES (r1), (r2), (r3);

-- 3. Using DEFAULT values
--    Just skip the column → it takes DEFAULT

-- ===================================================================
-- THEORY SECTION 3: SELECT – All Basic Variations
-- ===================================================================

-- SELECT *                  → All columns
-- SELECT name, city         → Specific columns
-- SELECT name AS full_name  → Rename column
-- SELECT DISTINCT city      → Remove duplicates
-- SELECT age + 5            → Simple calculations

-- ===================================================================
-- PHASE 1: Fresh Start
-- ===================================================================

DROP DATABASE IF EXISTS mysql_learning;
CREATE DATABASE mysql_learning;
USE mysql_learning;

-- ===================================================================
-- PHASE 2: Perfect Table with Surrogate Primary Key
-- ===================================================================

CREATE TABLE customers (
    id          INT PRIMARY KEY AUTO_INCREMENT,    -- Surrogate key (perfect)
    name        VARCHAR(50) NOT NULL,
    email       VARCHAR(100) UNIQUE NOT NULL,       -- No duplicate emails
    phone       VARCHAR(15),                        -- Optional
    city        VARCHAR(50) DEFAULT 'Unknown',
    age         TINYINT,
    joined_date DATE DEFAULT (CURRENT_DATE)
);

DESC customers;

-- ===================================================================
-- PHASE 3: All INSERT Methods – Full Demo
-- ===================================================================

-- Standard + multiple rows (BEST PRACTICE)
INSERT INTO customers (name, email, phone, city, age) VALUES
('Rahul Sharma',    'rahul@gmail.com',    '9876543210', 'Delhi',      28),
('Priya Singh',     'priya@yahoo.com',    '9876543211', 'Mumbai',     24),
('Aman Verma',      'aman@hotmail.com',   '9876543212', 'Bangalore',  31),
('Sneha Kapoor',    'sneha@gmail.com',    '9876543213', 'Pune',       29),
('Vikram Rao',      'vikram@outlook.com', NULL,         'Hyderabad',  45);

-- Using DEFAULT (city and joined_date will be auto-filled)
INSERT INTO customers (name, email, age) VALUES
('Rohan Das', 'rohan@gmail.com', 26),
('Neha Gupta', 'neha@gmail.com', 30);

SELECT * FROM customers;

-- ===================================================================
-- PHASE 4: SELECT – Every Important Pattern
-- ===================================================================

SELECT * FROM customers;
SELECT name, city FROM customers;
SELECT name AS "Full Name", age FROM customers;
SELECT DISTINCT city FROM customers;
SELECT name, age + 5 AS "Age in 2030" FROM customers;

-- ===================================================================
-- PHASE 5: Primary Key & AUTO_INCREMENT in Action
-- ===================================================================

-- This will FAIL → duplicate email
-- INSERT INTO customers (name, email) VALUES ('Test', 'rahul@gmail.com');

-- This will FAIL → cannot set same id
-- INSERT INTO customers (id, name, email) VALUES (3, 'Force', 'force@gmail.com');

-- AUTO_INCREMENT automatically gave ids: 1,2,3...

-- ===================================================================
-- MANDATORY PRACTICE: Insert 50+ Real Customers (DO THIS NOW!)
-- ===================================================================

-- Goal → Total rows > 50
-- Use realistic Indian names & cities
-- Mix phone present / null
-- Use bulk INSERT (5–10 rows at a time)

-- Example batches below – keep adding

INSERT INTO customers (name, email, phone, city, age) VALUES
('Arjun Patel',     'arjun@gmail.com',     '9123456780', 'Ahmedabad', 35),
('Pooja Desai',     'pooja@gmail.com',     '9123456781', 'Surat',     29),
('Rajesh Kumar',    'rajesh@gmail.com',    NULL,         'Patna',     42),
('Sunita Yadav',    'sunita@gmail.com',    '9123456783', 'Lucknow',   38),
('Deepak Joshi',    'deepak@gmail.com',    '9123456784', 'Indore',    31);

INSERT INTO customers (name, email, city, age) VALUES
('Kavya Sharma',    'kavya@gmail.com',     'Jaipur',    27),
('Nitin Agarwal',   'nitin@gmail.com',     'Nagpur',    39),
('Shalini Mehta',   'shalini@gmail.com',   'Bhopal',    33),
('Meera Nair',      'meera@gmail.com',     'Kochi',     26),
('Suresh Babu',     'suresh@gmail.com',    'Vizag',     44);

-- [ YOUR 40+ MORE INSERTS START HERE ] ----------------------------------






-- Final count check
SELECT COUNT(*) AS total_customers FROM customers;

-- Show latest 10
SELECT * FROM customers ORDER BY id DESC LIMIT 10;

-- ===================================================================
-- END OF FILE 3
-- You have mastered exactly what the syllabus demands:
-- • Surrogate Primary Key + AUTO_INCREMENT
-- • Every safe INSERT pattern
-- • Every basic SELECT pattern
-- • Inserted 50+ real rows like a pro

-- Next → File 4: WHERE Clause Mastery + 100% Safe UPDATE & DELETE
-- ===================================================================