-- Calculate range of the price column from the table foods
SELECT MAX(fd_price) - MIN(fd_price) AS range
FROM foods;

