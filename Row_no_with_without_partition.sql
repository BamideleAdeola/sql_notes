--Query1 --Comparing Row_number(), Rank() and Desne_rank() function without Partition BY clause
SELECT *, 
	ROW_NUMBER () OVER (ORDER BY fd_price) AS row_no,
	RANK () OVER (ORDER BY fd_price) AS ranks,	
	DENSE_RANK () OVER (ORDER BY fd_price) AS dense_ranks	
FROM foods;

--Query2 --Comparing Row_number(), Rank() and Desne_rank() function with Partition BY clause
SELECT *, 
	ROW_NUMBER () OVER (PARTITION BY fd_group ORDER BY fd_price) AS row_no,
	RANK () OVER (PARTITION BY fd_group ORDER BY fd_price) AS ranks,	
	DENSE_RANK () OVER (PARTITION BY fd_group ORDER BY fd_price) AS dense_ranks	
FROM foods;