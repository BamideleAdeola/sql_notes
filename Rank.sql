-- Find rank of fortune500 Companies in Fortune500 table according to revenue within each sector. 
SELECT 
	title AS company, 
	revenues AS coy_revenue,
	sector,
	RANK() OVER(ORDER BY revenues DESC) AS Rankings -- This ranks without any partition.
FROM fortune500
WHERE revenues IS NOT NULL;


-- Find rank of fortune500 Companies in Fortune500 table according to revenue within each sector and partition by sector. 
SELECT 
	title AS company, 
	revenues AS coy_revenue,
	sector,
	RANK() OVER(PARTITION BY sector ORDER BY revenues DESC) AS Rankings -- This ranks without any partition.
FROM fortune500
WHERE revenues IS NOT NULL;