-- Find rank of fortune500 Companies in Fortune500 table according to revenue within each sector. 
SELECT 
	title AS company, 
	revenues AS coy_revenue,
	sector,
	RANK() OVER(ORDER BY revenues DESC) AS Rankings
FROM fortune500
WHERE revenues IS NOT NULL;