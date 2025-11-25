-- =====================================================
-- MYSQL LEARNING SERIES
-- File 1: Complete Theory + Keywords + CRUD + Practice
-- =====================================================

-- ===================================================================
-- FULL THEORY SECTION (Your Foundation)
-- ===================================================================

-- 1. What is a Database?
-- An organized collection of data stored electronically for easy access, management & update.
-- Examples: Phone contacts, Amazon products, Bank transactions, Student records.

-- 2. What is a DBMS?
-- Software that lets us create, read, update and delete data in a database.
-- MySQL = Free, open-source, relational DBMS.

-- 3. SQL vs MySQL
-- SQL  → The language (like English)
-- MySQL → The software that understands SQL (like a person who speaks English)

-- 4. CRUD – The 4 Basic Operations
-- C → Create → INSERT
-- R → Read   → SELECT
-- U → Update → UPDATE
-- D → Delete → DELETE / DROP

-- ===================================================================
-- ALL IMPORTANT KEYWORDS EXPLAINED
-- ===================================================================

-- CREATE DATABASE → Makes new empty database
-- USE             → Enter that database
-- SHOW DATABASES  → List all databases
-- SHOW TABLES     → List all tables
-- DESC            → Show table structure

-- CREATE TABLE    → Define a new table
-- INT             → Whole numbers
-- VARCHAR(n)      → Text up to n characters
-- DECIMAL(p,s)    → Exact money values
-- INSERT INTO     → Add new rows
-- VALUES          → Actual data

-- SELECT          → Retrieve data
-- FROM            → From which table
-- WHERE           → Filter rows
-- UPDATE          → Change data
-- SET             → Assign new value
-- DELETE FROM     → Remove rows
-- TRUNCATE TABLE  → Delete all rows fast
-- DROP            → Permanently delete table/database

-- ===================================================================
-- PHASE 1: Create Database & First Table
-- ===================================================================

CREATE DATABASE mysql_learning;
USE mysql_learning;

CREATE TABLE students (
    id      INT,
    name    VARCHAR(50),
    age     INT,
    city    VARCHAR(50)
);

DESC students;

-- ===================================================================
-- PHASE 2: INSERT Data (Create)
-- ===================================================================

INSERT INTO students VALUES
(1, 'Arpit',    22, 'Delhi'),
(2, 'Priya',    19, 'Mumbai'),
(3, 'Rohan',    25, 'Bangalore'),
(4, 'Sneha',    21, 'Pune'),
(5, 'Vikram',   23, 'Hyderabad'),
(6, 'Aisha',    20, 'Chennai');

-- ===================================================================
-- PHASE 3: SELECT, UPDATE, DELETE
-- ===================================================================

SELECT * FROM students;
SELECT name, city FROM students WHERE age >= 21;

UPDATE students SET city = 'New Delhi' WHERE id = 1;
DELETE FROM students WHERE age < 20;

-- ===================================================================
-- LOGICAL EXECUTION ORDER OF SELECT QUERY (MOST IMPORTANT!)
-- This is the REAL order MySQL follows (NOT the order you write!)
-- ===================================================================

-- You write:   SELECT ... FROM ... WHERE ... ORDER BY ... LIMIT ...
-- MySQL executes in this exact sequence:

-- 1. FROM      → First picks the table
-- 2. WHERE     → Filters rows (removes unwanted ones)
-- 3. SELECT    → Chooses columns / does calculations
-- 4. ORDER BY  → Sorts the result
-- 5. LIMIT     → Takes only required number of rows

-- Memory trick: F → W → S → O → L  (From → Where → Select → Order → Limit)

-- Example query:
SELECT name, age FROM students WHERE city = 'Delhi' ORDER BY age DESC LIMIT 2;

-- Actual execution steps:
-- 1. FROM students
-- 2. WHERE city = 'Delhi'          → only Delhi rows remain
-- 3. SELECT name, age              → pick these two columns
-- 4. ORDER BY age DESC             → sort oldest first
-- 5. LIMIT 2                       → return only top 2

-- ===================================================================
-- PRACTICE QUESTIONS (Solve first → then check solutions)
-- ===================================================================

-- QUESTION 1:
-- Create table "mobile_phones" with columns:
-- phone_id (INT), brand (VARCHAR(50)), price (DECIMAL(10,2)), storage_gb (INT)

-- [ YOUR CODE HERE ] ----------------------------------------------------






-- QUESTION 2:
-- Insert at least 7 phones (real brands & prices)

-- [ YOUR CODE HERE ] ----------------------------------------------------






-- QUESTION 3:
-- Show phones that cost more than 25000 AND have 128GB or more storage

-- [ YOUR CODE HERE ] ----------------------------------------------------






-- QUESTION 4:
-- Give 12% discount to all Samsung and OnePlus phones

-- [ YOUR CODE HERE ] ----------------------------------------------------






-- QUESTION 5:
-- Delete all phones cheaper than 15000

-- [ YOUR CODE HERE ] ----------------------------------------------------






-- ===================================================================
-- SOLUTIONS (Check only after you try!)
-- ===================================================================

-- SOLUTION 1
CREATE TABLE mobile_phones (
    phone_id     INT,
    brand        VARCHAR(50),
    price        DECIMAL(10,2),
    storage_gb   INT
);

-- SOLUTION 2
INSERT INTO mobile_phones VALUES
(1, 'Samsung',  34999.00, 128),
(2, 'Apple',    79999.00, 256),
(3, 'OnePlus',  44999.00, 256),
(4, 'Xiaomi',   18999.00, 128),
(5, 'Realme',   15999.00, 64),
(6, 'Google',   59999.00, 128),
(7, 'Vivo',     22999.00, 128);

-- SOLUTION 3
SELECT * FROM mobile_phones WHERE price > 25000 AND storage_gb >= 128;

-- SOLUTION 4
UPDATE mobile_phones SET price = price * 0.88 
WHERE brand IN ('Samsung', 'OnePlus');

-- SOLUTION 5
DELETE FROM mobile_phones WHERE price < 15000;

-- Final result
SELECT * FROM mobile_phones;

-- ===================================================================
-- END OF FILE 1
-- You have completed the strongest possible File 1
-- Theory ✓ | Keywords ✓ | CRUD ✓ | Logical Order ✓ | Practice ✓
--
-- Next → File 2: Every MySQL Data Type in Depth + Constraints
-- ===================================================================