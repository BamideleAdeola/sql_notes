SELECT primary_poc
FROM accounts;

SELECT primary_poc,
       POSITION(' ' IN primary_poc)       
FROM accounts;


SELECT primary_poc,
       LEFT(primary_poc, POSITION(' ' IN primary_poc)-1 ) first_name,
       RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc))  last_name
FROM accounts;


SELECT name from sales_reps;


SELECT name,
       LEFT(name, STRPOS(name, ' ')-1) rep_firstname,
       RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) rep_lastname
FROM sales_reps;


SELECT * 
FROM accounts;

WITH t1 AS (
SELECT primary_poc, 
    LEFT( primary_poc, STRPOS(primary_poc , ' ')-1 ) firstname,
    RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc , ' ')) lastname,
    name
FROM accounts
)
SELECT primary_poc, CONCAT(firstname, '.', lastname, '@',name,'.com' ) email
FROM t1;

WITH t1 AS (
SELECT primary_poc, 
    LEFT( primary_poc, STRPOS(primary_poc , ' ')-1 ) firstname,
    RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc , ' ')) lastname,
    name
FROM accounts
)
SELECT primary_poc, LOWER(CONCAT(firstname, '.', lastname, '@',REPLACE(name, ' ',''),'.com' )) email
FROM t1;


WITH t1 AS (
SELECT primary_poc, 
    LEFT( primary_poc, STRPOS(primary_poc , ' ')-1 ) firstname,
    RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc , ' ')) lastname,
    name
FROM accounts
)
SELECT CONCAT(
    LOWER(LEFT(firstname, 1)),
    LOWER(RIGHT(firstname, 1)),
    LOWER(LEFT(lastname, 1)),
    LOWER(RIGHT(lastname, 1)),
    LOWER(LEFT(lastname, 1)),
    LENGTH(firstname),
    LENGTH(lastname),
    UPPER(REPLACE(name, ' ', ''))
    ) AS password
FROM t1;




-- WINDOW KEY
SELECT * 
FROM orders;

SELECT standard_qty, 
       SUM(standard_qty) OVER (ORDER BY occurred_at) runningtotal
FROM orders;


SELECT standard_qty, 
       DATE_TRUNC('month', occurred_at) AS month,
       SUM(standard_qty) OVER (
           PARTITION BY 
           DATE_TRUNC('QUARTER', occurred_at) 
           ORDER BY occurred_at) runningtotal
FROM orders;



SELECT total_amt_usd,
DATE_PART('YEAR', occurred_at) AS month,
SUM(total_amt_usd) OVER (PARTITION BY DATE_TRUNC('month', occurred_at) ORDER BY occurred_at) runningtot
FROM orders;



SELECT total_amt_usd,
       DATE_TRUNC('year', occurred_at) trunc_year,
       SUM(total_amt_usd) OVER ( PARTITION BY DATE_TRUNC('year', occurred_at) ORDER BY occurred_at) runningtotal
FROM orders;


/*
Ranking Total Paper Ordered by Account
Select the id, account_id, and total variable from the orders table, 
then create a column called total_rank that ranks this total 
amount of paper ordered (from highest to lowest) for each account using a partition. 
Your final table should have these four columns.
*/

SELECT id, 
       account_id, 
       total,
       RANK() OVER (PARTITION BY account_id ORDER BY total DESC) AS total_rank
FROM orders;


SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS max_std_qty
FROM orders;


-- REMOVING ORDER BY 
/*
Now remove ORDER BY DATE_TRUNC('month',occurred_at) in each line of the query that contains it in the SQL Explorer below. 
Evaluate your new query, compare it to the results in the SQL Explorer above, and answer the subsequent quiz questions.
*/
SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS max_std_qty
FROM orders;



-- Creating an ALias to shorten a window function
SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS count_total_amt_usd,
       AVG(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS min_total_amt_usd,
       MAX(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS max_total_amt_usd
FROM orders;

SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER main_window_syntax AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER main_window_syntax AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER main_window_syntax AS count_total_amt_usd,
       AVG(total_amt_usd) OVER main_window_syntax AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER main_window_syntax AS min_total_amt_usd,
       MAX(total_amt_usd) OVER main_window_syntax AS max_total_amt_usd
FROM orders
WINDOW main_window_syntax AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at))


