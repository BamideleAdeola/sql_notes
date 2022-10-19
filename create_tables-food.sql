CREATE TABLE foods(
fd_group VARCHAR(50),
fd_name VARCHAR(50),
fd_price integer
);

-- Copy the datasets from the localdrive 
-- COPY foods(fd_group,fd_name,fd_price)
-- FROM ‘C:foods.csv’
-- DELIMITER ‘,’
-- CSV HEADER;
