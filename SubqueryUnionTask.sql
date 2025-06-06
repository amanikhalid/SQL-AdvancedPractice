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

-- 3. Extra Challenge:
-- o Write a DML statement (like UPDATE or DELETE) that uses a subquery in the WHERE clause.
-- o Example: Delete all applicants whose email matches someone in the trainees table.
DELETE FROM Applicants WHERE Email IN ( SELECT Email FROM Trainees );

------------------------
--Batch Script & Transactions 
-- Goal: Understand how to safely execute multiple SQL statements as a unit. 
--4. Research: 
--o What is a SQL transaction?
--A series of one or more SQL operations carried out as a single work unit.
--In order to preserve data integrity, it makes sure that either all operations are completed or none are applied.

--How to write transaction blocks in your database tool (BEGIN TRANSACTION, COMMIT, ROLLBACK)?

BEGIN TRANSACTION;
-- SQL statements go here
-- e.g., INSERT, UPDATE, DELETE

COMMIT;  -- Finalize changes
-- If something goes wrong, you can use:
-- ROLLBACK;  -- Undo changes

--5. Task: 
--o Write a script that: 
--▪ Starts a transaction 
--▪ Tries to insert two new applicants 
--▪ The second insert should have a duplicate ApplicantID (to force failure) 
--▪ Rollback the whole transaction if any error occurs

BEGIN TRANSACTION;

BEGIN TRY
    INSERT INTO Applicant (ApplicantID, Name, Email)
    VALUES (101, 'Ellesa AlArs', 'ellesa@example.com');

    INSERT INTO Applicant (ApplicantID, Name, Email)
    VALUES (101, 'Zeyad AlRawahi', 'zeyad@example.com');  -- Duplicate

    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Transaction failed and was rolled back.';
END CATCH;

--6. Add this logic: 
--BEGIN TRANSACTION; 
--INSERT INTO Applicants VALUES (104, 'Zahra Al Amri', 'zahra.a@example.com', 'Referral', '2025-05-10'); 
--INSERT INTO Applicants VALUES (104, 'Error User', 'error@example.com', 'Website', '2025-05-11'); -- Duplicate ID 
--COMMIT; 
-- Or use ROLLBACK if needed

-- Disable autocommit to manage the transaction manually
SET autocommit = 0;

START TRANSACTION;

-- Try to insert two applicants
INSERT INTO Applicants
VALUES (104, 'Zahra Al Amri', 'zahra.a@example.com', 'Referral', '2025-05-10');

-- This insert will fail due to duplicate ApplicantID
INSERT INTO Applicants
VALUES (104, 'Error User', 'error@example.com', 'Website', '2025-05-11');

-- Commit if everything worked (won't be reached due to error above)
COMMIT;

-- Rollback should be issued manually after the error is caught
-- ROLLBACK;

------------------------
--ACID Properties Exploration 
--Goal: Learn the theory behind reliable transactions. 
--7. Research and summarize each of the ACID properties: 
--o Atomicity 
--A transaction must go through all of its steps successfully, or none at all.
--o Consistency 
--The database must be moved from one valid state to another by a transaction.
--o Isolation 
--When transactions are carried out concurrently, they shouldn't conflict with one another.
--o Durability 
--Changes made to a transaction must remain after it has been committed, even if it crashes.

--8. For each property, write a real-life example that explains it in your own words.
--Atomicity 
--Theory: A transaction's operations are either applied successfully or not.

 --Real-life example:
 --Consider moving funds from your account to your friend's using an ATM. 
--The bank would be in an invalid state if the ATM took money out of your account but did not transfer it to your friend's account.  Because of atomicity, either:
 --both activities are successful, or Neither occurs; the funds stay in your account.

--Consistency 
--Theory: A transaction must adhere to constraints and data types in order to exit the database in a valid state.

 --Real-life example:
--Suppose you purchase a concert ticket online. 
--The system may oversell tickets if your reservation is confirmed but it is unable to decrease the number of seats available.
--Every transaction complies with regulations (such as "available_seats ≥ 0") when there is consistency.

--Isolation
--Theory: Concurrent transactions shouldn't affect one another.

 --Real-life example: 
  --Two individuals attempt to reserve the hotel's final room simultaneously. 
--Both transactions could see the room as available and make a reservation if isolation was not present. 
--This is avoided by isolation, which ensures that only one person succeeds by managing one booking at a time under the hood.

--Durability
--Theory: a transaction remains committed even in the event of a system failure.

--Real-life example:  
--You place an online order successfully, and your payment has been approved. 
--You expect the order to be recorded even if the server crashes right after. 
--Durability guarantees that the data is permanently stored by the system (e.g., to disk or logs).

