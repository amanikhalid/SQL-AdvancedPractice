--  Use ITI DB 

use ITI;

-- 1.   Create a scalar function that takes date and returns Month name of that date. 
CREATE FUNCTION dbo.GetMonthName (@inputDate DATE)
RETURNS VARCHAR(20)
AS
BEGIN
    RETURN DATENAME(MONTH, @inputDate)
END

