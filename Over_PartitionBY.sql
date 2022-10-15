-- Using a subquery approach
SELECT title As Company, 
	fortune500.revenues AS revenue, 
	fortune500.sector AS sector,
	subquery.rev_totals,
	subquery.avgRev,
	subquery.maxRev,
	subquery.minRev
FROM fortune500
INNER JOIN
	(SELECT sector,
		SUM(revenues) AS rev_totals,
		AVG(revenues) AS avgRev,
		MAX(revenues) AS maxRev,
		MIN(revenues) AS minRev
		FROM fortune500
	GROUP BY sector) AS subquery
ON fortune500.sector = subquery.sector;
----------------------------------------------------------------------

--Using window function of OVER() and PARTITION BY Clause
SELECT title As Company, revenues, sector,
	SUM(revenues) OVER (PARTITION BY sector) AS rev_totals,
	AVG(revenues) OVER (pARTITION by sector) AS avgRev,
	MAX(revenues) OVER (pARTITION by sector) AS maxRev,
	MIN(revenues) OVER (pARTITION by sector) AS minRev
FROM fortune500;