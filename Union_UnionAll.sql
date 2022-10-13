-- Using the Northwind Sample Dataset from Microsoft
--Q1 Retrieve all cities from the customer and suppliers table 
SELECT City from Customers
UNION			-- This removes duplicates (93 rows returned)
SELECT City from Suppliers;
GO
----------------------------------------------------------

SELECT City from Customers
UNION ALL		-- Combines all with duplicates (120 rows returned)
SELECT City from Suppliers;
GO


--Q2 Retrieve all cities and countries from the customer and suppliers table where country is UK or Mexico
SELECT City, Country FROM Customers
WHERE Country IN ('UK', 'Mexico')
UNION
SELECT City, Country FROM Suppliers
WHERE Country IN ('UK', 'Mexico')
ORDER BY City;
GO

SELECT City, Country FROM Customers
WHERE Country IN ('UK', 'Mexico')
UNION ALL
SELECT City, Country FROM Suppliers
WHERE Country IN ('UK', 'Mexico')
ORDER BY City;
GO
----------------------------------------------------------

--Q3 Retrieve all cities and countries from the customer and suppliers table where country is Germany or Mexico
SELECT 'Customer' AS Type, ContactName, City, Country
FROM Customers
UNION
SELECT 'Supplier', ContactName, City, Country
FROM Suppliers;