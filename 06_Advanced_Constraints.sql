-- =====================================================
-- MYSQL LEARNING SERIES - FILE 6
-- Topic: CASE Statement • UNIQUE • CHECK • ALTER TABLE
-- Goal: Write bulletproof, self-protecting databases
-- =====================================================

-- ===================================================================
-- THEORY SECTION 1: CASE Statement – The IF/ELSE of SQL
-- ===================================================================
-- CASE is like a switch/if-else inside your query
-- Two forms:
-- 1. Simple CASE
--    CASE column WHEN value1 THEN result1 WHEN value2 THEN result2 ELSE default END

-- 2. Searched CASE (more powerful)
--    CASE WHEN condition1 THEN result1 WHEN condition2 THEN result2 ELSE default END

-- Use it for: grading, status labels, bucketing, dynamic logic

-- ===================================================================
-- THEORY SECTION 2: Advanced Constraints
-- ===================================================================
-- UNIQUE    → No duplicates allowed (except NULL)
-- CHECK     → Custom rule (age > 18, salary >= 0, etc.)
-- ALTER TABLE → Change table structure after creation (real projects!)

-- ===================================================================
-- PHASE 1: Fresh Start + Realistic Data
-- ===================================================================

DROP DATABASE IF EXISTS mysql_learning;
CREATE DATABASE mysql_learning;
USE mysql_learning;

-- Students table with strict constraints
CREATE TABLE students (
    student_id    INT PRIMARY KEY AUTO_INCREMENT,
    name          VARCHAR(50) NOT NULL,
    email         VARCHAR(100) UNIQUE NOT NULL,          -- No duplicate emails
    phone         VARCHAR(15) UNIQUE,                    -- Optional but unique
    age           TINYINT CHECK (age >= 17 AND age <= 30), -- College age only
    percentage    DECIMAL(5,2) CHECK (percentage BETWEEN 0 AND 100),
    grade         CHAR(1) CHECK (grade IN ('A','B','C','D','F')),
    status        VARCHAR(20) DEFAULT 'Active',
    admission_year YEAR DEFAULT (YEAR(CURDATE())),
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DESC students;

-- ===================================================================
-- PHASE 2: Insert Data – See Constraints in Action
-- ===================================================================

INSERT INTO students (name, email, phone, age, percentage, grade) VALUES
('Rahul Sharma',    'rahul@college.edu',    '9876543210', 21, 88.50, 'A'),
('Priya Singh',     'priya@college.edu',    '9876543211', 19, 92.30, 'A'),
('Aman Verma',      'aman@college.edu',     NULL,         22, 76.80, 'B'),
('Sneha Kapoor',    'sneha@college.edu',    '9876543213', 20, 96.40, 'B'),
('Vikram Rao',      'vikram@college.edu',   '9876543214', 23, 69.90, 'C');

-- These will FAIL → see error messages!
-- INSERT INTO students (name, email, age) VALUES ('Duplicate', 'rahul@college.edu', 20); -- duplicate email
-- INSERT INTO students (name, email, age) VALUES ('Old', 'old@college.edu', 35);             -- age violation
-- INSERT INTO students (name, email, percentage) VALUES ('Bad', 'bad@college.edu', 150);     -- percentage > 100

-- ===================================================================
-- PHASE 3: CASE Statement – All Real-World Patterns
-- ===================================================================

-- Simple CASE: Convert grade to meaning
SELECT 
    name,
    grade,
    CASE grade
        WHEN 'A' THEN 'Excellent'
        WHEN 'B' THEN 'Good'
        WHEN 'C' THEN 'Average'
        WHEN 'D' THEN 'Poor'
        ELSE 'Fail'
    END AS performance
FROM students;

-- Searched CASE: Custom status
SELECT 
    name,
    percentage,
    CASE 
        WHEN percentage >= 90 THEN 'Topper'
        WHEN percentage >= 75 THEN 'First Class'
        WHEN percentage >= 60 THEN 'Second Class'
        WHEN percentage >= 35 THEN 'Pass'
        ELSE 'Fail'
    END AS result_status
FROM students;

-- CASE in ORDER BY (dynamic sorting)
SELECT name, percentage 
FROM students 
ORDER BY 
    CASE WHEN percentage >= 90 THEN 1 ELSE 2 END,
    percentage ASC; 

-- ===================================================================
-- PHASE 4: ALTER TABLE – Real Project Commands
-- ===================================================================

SELECT * FROM students;

-- Add new column
ALTER TABLE students ADD COLUMN city VARCHAR(50) DEFAULT 'Unknown';

-- Modify existing column
ALTER TABLE students MODIFY COLUMN phone VARCHAR(15);  -- allow NULL again if needed

-- Drop column
ALTER TABLE students DROP COLUMN city;

-- Add CHECK constraint (MySQL 8.0.16+)
ALTER TABLE students ADD CONSTRAINT chk_positive_percentage 
CHECK (percentage >= 0);

-- Drop constraint
ALTER TABLE students DROP CHECK chk_positive_percentage;

-- Rename column (MySQL 8.0+)
ALTER TABLE students RENAME COLUMN percentage TO marks_obtained;

-- Rename table
ALTER TABLE students RENAME TO college_students;

SELECT * FROM college_students;

-- ===================================================================
-- PRACTICE QUESTIONS – WRITE FIRST!
-- ===================================================================

-- Q1: Add a column "attendance" (0-100) with CHECK constraint (>= 75 is good)
-- [ YOUR CODE HERE ] ----------------------------------------------------






-- Q2: Use CASE to label students: "Distinction" (>=85), "First Class" (>=70), "Pass" (>=35), "Fail"
-- [ YOUR CODE HERE ] ----------------------------------------------------






-- Q3: Add a new column "scholarship" DECIMAL(10,2) and set 5000 for toppers (>90), 2000 for >80, else 0
--     (Use UPDATE with CASE)
-- [ YOUR CODE HERE ] ----------------------------------------------------






-- Q4: Try inserting a student with age 15 → see CHECK error
-- [ YOUR CODE HERE ] ----------------------------------------------------






-- Q5: Drop the grade column and add a new column "stream" (Science/Commerce/Arts)
-- [ YOUR CODE HERE ] ----------------------------------------------------






-- ===================================================================
-- SOLUTIONS (Only after you try!)
-- ===================================================================

-- Q1
ALTER TABLE college_students ADD COLUMN attendance TINYINT CHECK (attendance BETWEEN 0 AND 100);

-- Q2
SELECT 
    name,
    marks_obtained,
    CASE 
        WHEN marks_obtained >= 85 THEN 'Distinction'
        WHEN marks_obtained >= 70 THEN 'First Class'
        WHEN marks_obtained >= 35 THEN 'Pass'
        ELSE 'Fail'
    END AS category
FROM college_students;

-- Q3
ALTER TABLE college_students ADD COLUMN scholarship DECIMAL(10,2) DEFAULT 0;

UPDATE college_students 
SET scholarship = CASE
    WHEN marks_obtained > 90 THEN 5000
    WHEN marks_obtained > 80 THEN 2000
    ELSE 0
END;

-- Q4
-- This will FAIL
-- INSERT INTO college_students (name, email, age) VALUES ('Child', 'child@school.edu', 15);

-- Q5
ALTER TABLE college_students DROP COLUMN grade;
ALTER TABLE college_students ADD COLUMN stream VARCHAR(20) 
CHECK (stream IN ('Science', 'Commerce', 'Arts'));

-- Final view
SELECT * FROM college_students;

-- ===================================================================
-- END OF FILE 6
-- You have mastered:
-- • CASE Statement (the most powerful tool in SQL)
-- • UNIQUE & CHECK constraints (data never lies)
-- • ALTER TABLE (real projects = constant changes)
-- • Writing self-validating, production-ready schemas

-- Next → File 7: Relationships & All Types of JOINs (The Holy Grail of SQL)
-- Just say "File 7" when you're ready – it's going to change everything!
-- ===================================================================