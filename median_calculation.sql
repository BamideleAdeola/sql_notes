-- Calculate the MEAN and MEDIAN of price column from the table foods. 
SELECT
	AVG(fd_price) AS mean,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY fd_price) AS median
FROM foods;