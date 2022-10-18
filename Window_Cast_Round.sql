--Using window function of OVER() and PARTITION BY Clause
SELECT title As Company, revenues, sector,
	SUM(revenues) OVER (PARTITION BY sector) AS rev_totals,
	ROUND(AVG(revenues) OVER (PARTITION by sector), 2) AS avgRev,
	MAX(revenues) OVER (pARTITION by sector) AS maxRev,
	MIN(revenues) OVER (pARTITION by sector) AS minRev
FROM fortune500;