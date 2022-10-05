--FULL OUTER JOIN
/*
1. each account who has a sales rep and each sales rep that has an account (all of the columns in these returned rows will be full)
2. but also each account that does not have a sales rep and each sales rep that does not have an account (some of the columns in these returned rows will be empty)
*/

-- 1. each account who has a sales rep and each sales rep that has an account 
-- (all of the columns in these returned rows will be full)
SELECT *
FROM accounts a
FULL JOIN sales_reps s 
ON a.sales_rep_id = s.id;

-- 2. but also each account that does not have a sales rep and each sales rep that does not have an account 
-- (some of the columns in these returned rows will be empty)

SELECT *
FROM accounts a
FULL JOIN sales_reps s 
ON a.sales_rep_id = s.id
WHERE a.sales_rep_id IS NULL OR s.id IS NULL;


SELECT 
        o.id,
        o.occurred_at AS order_date,
        w.*
FROM orders o
LEFT JOIN web_events w
    ON w.account_id = o.account_id
    AND w.occurred_at < o.occurred_at
WHERE DATE_TRUNC('month', o.occurred_at) =
    (SELECT DATE_TRUNC('month', MIN(o.occurred_at) ) FROM orders o)
ORDER BY o.account_id, o.occurred_at;

--INEQUALITY JOINS

/*
write a query that left joins the accounts table and the sales_reps tables on each sale rep's ID number and joins it 
using the < comparison operator on accounts.primary_poc and sales_reps.name, 
like so:
*/

SELECT 
    a.name AS accountname,
    a.primary_poc AS contacts,
    s.name AS salesreps
FROM accounts a
LEFT JOIN sales_reps s
ON  a.sales_rep_id = s.id
AND a.primary_poc < s.name;



-- LEFT JOIN SAME TABLE
SELECT o1.id AS o1_id,
       o1.account_id AS o1_account_id,
       o1.occurred_at AS o1_occurred_at,
       o2.id AS o2_id,
       o2.account_id AS o2_account_id,
       o2.occurred_at AS o2_occurred_at
  FROM orders o1
 LEFT JOIN orders o2
   ON o1.account_id = o2.account_id
  AND o2.occurred_at > o1.occurred_at
  AND o2.occurred_at <= o1.occurred_at + INTERVAL '28 days'
ORDER BY o1.account_id, o1.occurred_at;

SELECT web1.id AS web1_id,
       web1.account_id AS web1_account_id,
       web1.occurred_at AS web1_occurred_at,
       web2.id AS web2_id,
       web2.account_id AS web2_account_id,
       web2.occurred_at AS web2_occurred_at
  FROM web_events web1
 LEFT JOIN web_events web2
   ON web1.account_id = web2.account_id
  AND web2.occurred_at > web1.occurred_at
  AND web2.occurred_at <= web1.occurred_at + INTERVAL '1 days'
ORDER BY web1.account_id, web2.occurred_at;


WITH double_acct AS(
SELECT *
FROM accounts ac1
where ac1.name = 'Walmart'
union ALL
SELECT * FROM accounts ac2
WHERE ac2.name = 'Disney')

SELECT name, count(*)
FROM double_acct
GROUP BY 1
ORDER BY 2 DESC;

WITH double_accounts AS (
    SELECT *
      FROM accounts

    UNION ALL

    SELECT *
      FROM accounts
)

SELECT name,
       COUNT(*) AS name_count
 FROM double_accounts 
GROUP BY 1
ORDER BY 2 DESC;


-- USE EXPLAIN TO KNOW HOW THE QUERY WILL RUN
EXPLAIN
WITH double_accounts AS (
    SELECT *
      FROM accounts

    UNION ALL

    SELECT *
      FROM accounts
)

SELECT name,
       COUNT(*) AS name_count
 FROM double_accounts 
GROUP BY 1
ORDER BY 2 DESC;