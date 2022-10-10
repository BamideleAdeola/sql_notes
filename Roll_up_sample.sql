
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