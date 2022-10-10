SELECT * FROM fortune500;

SELECT 
	sector, 
	SUM(revenues) AS total_revenue
FROM fortune500
GROUP BY sector; --Grouping revenue by just the distinct sectors

-- Retrieve aggregate revenue value for individual sectors and all sectors aggregate revenue.
SELECT 
	COALESCE(sector, 'All Sectors') As sector,
	SUM(revenues) AS total_revenue
FROM fortune500
GROUP BY ROLLUP (sector); --Group revenue with a mindset of total revenue for all sectors


-- ROLL UP WITH 2 GROUPING SETS
SELECT
    sector,
    industry,
    SUM(revenues) AS total_revenue
FROM
    fortune500
GROUP BY
    ROLLUP(sector, industry);

/*
Note that if you change the order of a grouping sets industry, sector 
the result will be different as shown in the following query:
*/

SELECT
    sector,
    industry,
    SUM(revenues) AS total_revenue
FROM
    fortune500
GROUP BY
    ROLLUP(industry, sector);


-- A partial rollup is also possible as seen below:
SELECT
    sector,
    industry,
    SUM(revenues) AS total_revenue
FROM
    fortune500
GROUP BY 
	sector,
    ROLLUP(industry);