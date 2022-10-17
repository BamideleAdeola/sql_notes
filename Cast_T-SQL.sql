SELECT CAST(38.75 AS int) AS Convert_to_int; -- decimal or float to integer Got truncated. removing the decimal points
GO

SELECT CAST(38.75 AS numeric) Convert_to_numeric; -- Rounded - Removed decimal points and approximate the value
GO

SELECT CAST(38.75 AS varchar) AS Convert_to_varchar; 
GO

SELECT CAST('2017-08-25' AS datetime) AS Convert_to_datetime;
GO

SELECT CAST('2017-08-25' AS date) AS Convert_to_date;
GO
