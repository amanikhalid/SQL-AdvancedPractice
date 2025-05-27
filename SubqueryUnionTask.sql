--create database

Create database SubqueryUnionTask;

use SubqueryUnionTask

-- Tables
-- Trainees Table
CREATE TABLE Trainees (
 TraineeID INT PRIMARY KEY,
 FullName VARCHAR(100),
 Email VARCHAR(100),
 Program VARCHAR(50),
 GraduationDate DATE
);

-- Job Applicants Table
CREATE TABLE Applicants (
 ApplicantID INT PRIMARY KEY,
 FullName VARCHAR(100),
 Email VARCHAR(100),
 Source VARCHAR(20), -- e.g., "Website", "Referral"
 AppliedDate DATE
);

------------------------

--Sample Data
--Insert into Trainees
INSERT INTO Trainees VALUES
(1, 'Layla Al Riyami', 'layla.r@example.com', 'Full Stack .NET', '2025-04-30'),
(2, 'Salim Al Hinai', 'salim.h@example.com', 'Outsystems', '2025-03-15'),
(3, 'Fatma Al Amri', 'fatma.a@example.com', 'Database Admin', '2025-05-01');

-- Insert into Applicants
INSERT INTO Applicants VALUES
(101, 'Hassan Al Lawati', 'hassan.l@example.com', 'Website', '2025-05-02'),
(102, 'Layla Al Riyami', 'layla.r@example.com', 'Referral', '2025-05-05'), -- same person as trainee
(103, 'Aisha Al Farsi', 'aisha.f@example.com', 'Website', '2025-04-28');

------------------------
select * from Applicants
select * from Trainees
 
-- Part 1: UNION Practice
-- 1. List all unique people who either trained or applied for a job.
-- o Show their full names and emails.
-- o Use UNION (not UNION ALL) to avoid duplicates.
SELECT FullName, Email FROM Trainees
UNION
SELECT FullName, Email FROM Applicants;

-- 2. Now use UNION ALL. What changes in the result?
-- o Explain why one name appears twice.

SELECT FullName, Email FROM Trainees
UNION ALL
SELECT FullName, Email FROM Applicants;

 -- Layla Al Riyami appears twice in UNION ALL because she is in both tables.-- 
 --  UNION removes duplicates; UNION ALL includes all records.-- 

-- 3. Find people who are in both tables.
-- o You must use INTERSECT if supported, or simulate it using INNER JOIN on Email.
SELECT T.FullName, T.Email
FROM Trainees T
INNER JOIN Applicants A ON T.Email = A.Email;

-- Part 2: DROP, DELETE, TRUNCATE Observation

-- 4. Try DELETE FROM Trainees WHERE Program = 'Outsystems'.
-- o Check if the table structure still exists.
DELETE FROM Trainees WHERE Program = 'Outsystems';

-- Observation: Row deleted, but table and other data remain.

-- 5. Try TRUNCATE TABLE Applicants.
-- o What happens to the data? Can you roll it back?
TRUNCATE TABLE Applicants;
-- Observation: All rows removed quickly. Cannot roll back in most DBs (non-logged operation).

-- 6. Try DROP TABLE Applicants.
-- o What happens if you run a SELECT after that?
DROP TABLE Applicants;
-- Observation: Table is permanently removed. SELECT after DROP gives an error.
-- Example:
-- SELECT * FROM Applicants; -- Will fail

-- Part 3: Self-Discovery & Applied Exploration
-- In this section, you’ll independently research, experiment, and apply advanced SQL concepts.
-- Follow the guided prompts below.
-- Subquery Exploration
-- Goal: Understand what a subquery is and how it's used inside SQL commands.

--1. Research: 
--o What is a subquery in SQL?
--A subquery is a query inside another SQL query, sometimes referred to as an inner query or nested query. 
--It is employed to carry out intermediate computations or data retrievals that are necessary for the main (outer) query.
 
--Example:Correlated Subquery:
SELECT name
FROM Employee e
WHERE salary > (
    SELECT AVG(salary)
    FROM Employee
    WHERE department_id = e.department_id
);
--This returns employees earning more than the average salary in their own department.

--Where can we use subqueries? (e.g., in SELECT, WHERE, FROM)
--A SQL statement can use subqueries in a number of important clauses to aid in data computation or retrieval.
--Here's an explanation of how and where to use them:

--1. Subquery in SELECT Clause
SELECT name, salary,
       (SELECT AVG(salary) FROM Employee) AS avg_company_salary
FROM Employee;

--2. Subquery in WHERE Clause
SELECT name
FROM Employee
WHERE department_id IN (
    SELECT id
    FROM Department
    WHERE location = 'Muscat'
);

--3. Subquery in FROM Clause
SELECT MAX(avg_salary) AS max_avg_salary
FROM (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM Employee
    GROUP BY department_id
) AS DeptAvg;

--4. Subquery in HAVING Clause
SELECT department_id, COUNT(*) AS emp_count
FROM Employee
GROUP BY department_id
HAVING COUNT(*) > (
    SELECT AVG(emp_count)
    FROM (
        SELECT COUNT(*) AS emp_count
        FROM Employee
        GROUP BY department_id
    ) AS DeptCounts
);

--5. Subquery in JOIN (FROM or JOIN as subquery)
SELECT s.name, b.branch_name
FROM Staff s
JOIN (
    SELECT branch_id
    FROM Staff
    GROUP BY branch_id
    HAVING COUNT(*) > 5
) AS BigBranches
ON s.branch_id = BigBranches.branch_id;

-- 2. Task:
-- o Write a query to find all trainees whose emails appear in the applicants table.
-- o You must use a subquery inside a WHERE clause.

SELECT *
FROM Trainees
WHERE Email IN (SELECT Email FROM Applicants);






