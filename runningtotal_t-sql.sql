/****** Running total using window function ******/
SELECT
	id,
	Country,
	Points,
	SUM(Points) OVER (ORDER BY id ASC) AS RunningTotal  -- cumulative addition of points
FROM eurovision;

-- Also, you can use it for orders;
SELECT
order_id,
sales_date,
salesperson,
order_value,
SUM(order_value)
  OVER (ORDER BY order_id ASC) AS RunningTotal
FROM sales_history;
