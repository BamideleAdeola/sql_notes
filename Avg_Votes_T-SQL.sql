/* Find Average total_votes of all voters residing in France, Germany and Switzerland 
by customer_id and country.
*/

SELECT customer_id, country, AVG(total_votes) AS avg_votes
FROM voters
WHERE country IN ('France', 'Germany', 'Switzerland') 
GROUP BY customer_id, country
ORDER BY customer_id, country;