/* COALESCE FUNCTION
Returns the first non-null value in a list.

*/
--------------------------------------
SELECT COALESCE(NULL, NULL, 'companyemail', NULL, NULL, 'Example.com') AS firstNonNull_character;

-- Here 1 is the first non-null character
SELECT COALESCE(NULL, 1, 2, 5, 8) AS firstNon_null_value;

------------------------------------
-- It is also used to give alternative values
SELECT 
	COALESCE(sector, 'All Sectors') As sector,
	SUM(revenues) AS total_revenue
FROM fortune500
GROUP BY ROLLUP (sector); --Group revenue with a mindset of total revenue for all sectors

-----------------------------
-- It is used to replace the NULL value with a simple text:
SELECT 
  first_name,
  last_name,
  COALESCE(marital_status,'Unknown')
FROM persons

-----------------------------------------------------
-- Coalesce Used to replace null values 
SELECT Name,
COALESCE(Class, 'No class') AS class,
COALESCE(Color, 'No color') AS color,
COALESCE(ProductNumber, 'No ProductNumber') AS ProductNumber
FROM Production.Product;

------------------------------------------------------

-- Comapring the 3 fields below, the first notnullvalue is returned with coalesce function

SELECT Name, Class, Color, ProductNumber,  
COALESCE(Class, Color, ProductNumber) AS FirstNotNull  
FROM Production.Product;
