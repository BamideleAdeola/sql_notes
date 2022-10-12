-- This has a total of 606 rows
SELECT [ProductKey] AS productkey_ProductTable
FROM dbo.DimProduct;
GO

-- This has a total of 60855 rows
SELECT  [ProductKey] AS productkey_FactResellerTable
FROM dbo.FactResellerSales;
GO


-- This has a total of 334 rows using INTERSECT
SELECT [ProductKey] AS productKey_Intersect
FROM dbo.DimProduct
INTERSECT
SELECT [ProductKey]
FROM dbo.FactResellerSales;
GO