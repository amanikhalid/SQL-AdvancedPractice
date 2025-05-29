--  Use ITI DB 

use ITI;

-- 1.   Create a scalar function that takes date and returns Month name of that date. 
CREATE FUNCTION dbo.GetMonthName (@inputDate DATE)
RETURNS VARCHAR(20)
AS
BEGIN
    RETURN DATENAME(MONTH, @inputDate)
END

-- 2.   Create a multi-statements table-valued function that takes 2 integers and returns the values between them. 
CREATE FUNCTION dbo.GetValuesBetween (@Start INT, @End INT)
RETURNS @Result TABLE (Number INT)
AS
BEGIN
    DECLARE @i INT = @Start
    WHILE @i <= @End
    BEGIN
        INSERT INTO @Result VALUES (@i)
        SET @i += 1
    END
    RETURN
END

-- 3.   Create inline function that takes Student No and returns Department Name with Student full name. 
CREATE FUNCTION dbo.GetStudentDeptName (@StudentNo INT)
RETURNS TABLE
AS
RETURN ( SELECT D.Dept_Name, S.St_Fname + ' ' + S.St_Lname AS FullName
FROM Student S
INNER JOIN Department D ON S.Dept_Id = D.Dept_Id
WHERE S.St_Id = @StudentNo )

-- 4.  Create a scalar function that takes Student ID and returns a message to user  
-- a.  If first name and Last name are null then display 'First name & last name are null' 
-- b.  If First name is null then display 'first name is null' 
-- c.  If Last name is null then display 'last name is null' 
-- d.  Else display 'First name & last name are not null' 
 
CREATE FUNCTION dbo.CheckStudentName (@StudentID INT)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @Fname VARCHAR(50), @Lname VARCHAR(50), @Msg VARCHAR(100)

    SELECT @Fname = St_Fname, @Lname = St_Lname FROM Student WHERE St_Id = @StudentID

    IF @Fname IS NULL AND @Lname IS NULL
        SET @Msg = 'First name & last name are null'
    ELSE IF @Fname IS NULL
        SET @Msg = 'first name is null'
    ELSE IF @Lname IS NULL
        SET @Msg = 'last name is null'
    ELSE
        SET @Msg = 'First name & last name are not null'

    RETURN @Msg
END

-- 5.  Create inline function that takes integer which represents manager ID and displays department name, Manager Name and hiring date  
CREATE FUNCTION dbo.GetManagerInfo (@MgrID INT)
RETURNS TABLE
AS
RETURN (
    SELECT 
        D.Dept_Name, 
        Ins.Ins_Name AS ManagerName, 
        D.Manager_hiredate
    FROM 
        Department D
    JOIN 
        Instructor Ins ON D.Dept_Id = Ins.Dept_Id
    WHERE 
        Ins.Ins_Id = @MgrID
)

-- 6.  Create multi-statements table-valued function that takes a string 
-- If string='first name' returns student first name 
-- If string='last name' returns student last name  
-- If string='full name' returns Full Name from student table 
-- Note: Use “ISNULL” function 
 
CREATE FUNCTION dbo.GetStudentNamePart (@Type VARCHAR(20))
RETURNS @Result TABLE (NamePart VARCHAR(100))
AS
BEGIN
    IF @Type = 'first name'
        INSERT INTO @Result SELECT ISNULL(St_Fname, 'N/A') FROM Student
    ELSE IF @Type = 'last name'
        INSERT INTO @Result SELECT ISNULL(St_Lname, 'N/A') FROM Student
    ELSE IF @Type = 'full name'
        INSERT INTO @Result SELECT ISNULL(St_Fname, '') + ' ' + ISNULL(St_Lname, '') FROM Student

    RETURN
END


