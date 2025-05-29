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


