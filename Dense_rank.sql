--Rank
SELECT *, 
	RANK () OVER (PARTITION BY FD_group ORDER BY fd_price) AS ranks	
FROM foods;

-- Dense Rank
SELECT *, 
	DENSE_RANK () OVER (PARTITION BY FD_group ORDER BY fd_price) AS dense_ranks	
FROM foods;

--comparing Rank() and Desne_rank() function
SELECT *, 
	RANK () OVER (PARTITION BY FD_group ORDER BY fd_price) AS ranks,	
	DENSE_RANK () OVER (PARTITION BY FD_group ORDER BY fd_price) AS dense_ranks	
FROM foods;