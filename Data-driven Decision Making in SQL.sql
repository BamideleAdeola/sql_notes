/*
DATA-driven Decision Making in SQL
*/

-- Select all movies rented on October 9th, 2018.
SELECT *
FROM renting
WHERE date_renting = '2018-10-09'; -- Movies rented on October 9th, 2018

-- Select all records of movie rentals between beginning of April 2018 till end of August 2018.
SELECT *
FROM renting
WHERE date_renting BETWEEN '2018-04-01' AND '2018-08-31'; -- from beginning April 2018 to end August 2018


/* CHALLENGE
Put the most recent records of movie rentals on top 
of the resulting table and order them in decreasing order.
*/

SELECT *
FROM renting
WHERE date_renting BETWEEN '2018-04-01' AND '2018-08-31'
ORDER BY date_renting DESC; -- Order by recency in decreasing order


/*SELECTING MOVIES
The table movies contains all movies available on the online platform.
*/

/* 
 a. Select all movies which are not dramas.
*/

SELECT *
FROM movies
WHERE genre != 'Drama'; -- All genres except drama

/* 
 b. Select the movies 'Showtime', 'Love Actually' and 'The Fighter'
*/

SELECT *
FROM movies
WHERE title IN ('Showtime', 'Love Actually', 'The Fighter'); -- Select all movies with the given titles

/* 
 c. Order the movies by increasing renting price.
*/
SELECT *
FROM movies
ORDER BY renting_price  ; -- Order the movies by increasing renting price


/* 
Select from table renting all movie rentals from 2018.
Filter only those records which have a movie rating.
*/

SELECT *
FROM renting
WHERE date_renting BETWEEN '2018-01-01' AND '2018-12-31' -- Renting in 2018
AND rating IS NOT NULL; -- Rating exists


/* 
Count the number of customers born in the 80s.
Count the number of customers from Germany.
Count the number of countries where MovieNow has customers.
*/
-- 1.Count the number of customers born in the 80s.
SELECT COUNT(*) -- Count the total number of customers
FROM customers
WHERE date_of_birth BETWEEN '1980-01-01' AND '1989-12-31'; 

-- 2.Count the number of customers from Germany.
SELECT COUNT(*)   -- Count the total number of customers
FROM customers
WHERE country = 'Germany'; -- Select all customers from Germany

-- 3.Count the number of countries where MovieNow has customers.

SELECT COUNT(DISTINCT country)   -- Count the number of countries
FROM customers;

/* 
Select all movie rentals of the movie with movie_id 25 
from the table renting.

For those records, calculate the minimum, maximum and 
average rating and count the number of ratings for this movie.
*/

SELECT MIN(rating) AS min_rating, -- Calculate the minimum rating and use alias min_rating
	   MAX(rating) AS max_rating, -- Calculate the maximum rating and use alias max_rating
	   AVG(rating) AS avg_rating, -- Calculate the average rating and use alias avg_rating
	   COUNT(rating) AS number_ratings -- Count the number of ratings and use alias number_ratings
FROM renting
WHERE movie_id = 25; -- Select all records of the movie with ID 25



/* Examining annual rentals
First, select all records of movie rentals since January 1st 2019.*/

SELECT * -- Select all records of movie rentals since January 1st 2019
FROM renting
WHERE date_renting >= '2019-01-01'; 


/* Examining annual rentals
Now, count the number of movie rentals and calculate the 
average rating since the beginning of 2019.*/

SELECT 
	COUNT(*), -- Count the total number of rented movies
	AVG(rating) -- Add the average rating
FROM renting
WHERE date_renting >= '2019-01-01';

/* Examining annual rentals
Now, count the number of movie rentals and calculate the 
average rating since the beginning of 2019.*/

SELECT 
	COUNT(*) AS number_renting, -- Give it the column name number_renting
	AVG(rating) AS average_rating  -- Give it the column name average_rating
FROM renting
WHERE date_renting >= '2019-01-01';

/* Examining annual rentals
Finally, count how many ratings exist since 2019-01-01.*/

SELECT 
	COUNT(*) AS number_renting,
	AVG(rating) AS average_rating, 
    COUNT(rating) AS number_ratings -- Add the total number of ratings here.
FROM renting
WHERE date_renting >= '2019-01-01';


/* THE GROUP BY CLAUSE
This is similar to SELECT DISTINCT but different in the fact 
one can add aggregate value to Group By but not Select distinct.
The HAVING CLAUSE IS always used after the GROUP BY clause to filter aggregation.
*/

/*
First account for each country.
Conduct an analysis to see when the first customer accounts were created for each country.
----------------------------------------------
STEPS>
Create a table with a row for each country and columns 
for the country name and the date when the first customer account was created.

Use the alias first_account for the column with the dates.

Order by date in ascending order.
*/

SELECT country, -- For each country report the earliest date when an account was created
	MIN(date_account_start) AS first_account
FROM customers
GROUP BY country
ORDER BY MIN(date_account_start);


/*
Average movie ratings
For each movie the average rating, the number of ratings 
and the number of views has to be reported. 
Generate a table with meaningful column names.
----------------------------------------------
STEPS>
1. Group the data in the table renting by movie_id and report the ID and the average rating.
2. Add two columns for the number of ratings and the 
number of movie rentals to the results table.
Use alias names avg_rating, number_rating and 
number_renting for the corresponding columns.
*/

-- 1. Group the data in the table renting by movie_id and report the ID and the average rating.
SELECT movie_id, 
       AVG(rating)    -- Calculate average rating per movie
FROM renting
GROUP BY movie_id;

--2 Add two columns for the number of ratings and the number of movie rentals to the results table.
-- Use alias names avg_rating, number_rating and number_renting for the corresponding columns.
SELECT movie_id, 
       AVG(rating) AS avg_rating, -- Use as alias avg_rating
       COUNT(rating) AS number_rating,                -- Add column for number of ratings with alias number_rating
       COUNT(*) AS number_renting                 -- Add column for number of movie rentals with alias number_renting
FROM renting
GROUP BY movie_id;

--3. Order the rows of the table by the average rating such that it is in decreasing order.
SELECT movie_id, 
       AVG(rating) AS avg_rating,
       COUNT(rating) AS number_ratings,
       COUNT(*) AS number_renting
FROM renting
GROUP BY movie_id
ORDER BY COUNT(rating) DESC; -- Order by average rating in decreasing order


/*
Group the data in the table renting by customer_id 
and report the customer_id, the average rating, the 
number of ratings and the number of movie rentals.

Select only customers with more than 7 movie rentals.
Order the resulting table by the average rating in ascending order.
*/

SELECT customer_id, -- Report the customer_id
      AVG(rating),  -- Report the average rating per customer
      COUNT(rating),  -- Report the number of ratings per customer
      COUNT(*)  -- Report the number of movie rentals per customer
FROM renting
GROUP BY customer_id
HAVING COUNT(*) > 7 -- Select only customers with more than 7 movie rentals
ORDER BY AVG(rating); -- Order by the average rating in ascending order


/* JOINS
*/

/*
Augment the table renting with all columns from the table customers with a LEFT JOIN.
Use as alias' for the tables r and c respectively.
*/
SELECT * -- Join renting with customers
FROM renting r
LEFT JOIN customers c
ON r.customer_id = c.customer_id;

/*
Select only records from customers coming from Belgium.
*/

SELECT *
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
WHERE c.country = 'Belgium'; -- Select only records from customers coming from Belgium

/*
Average ratings of customers from Belgium.
*/

SELECT AVG(rating) -- Average ratings of customers from Belgium
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
WHERE c.country='Belgium';


/*
Aggregating revenue, rentals and active customers

Important KPIs are, therefore, the profit coming from movie rentals, 
the number of movie rentals and the number of active customers.
*/
/*
Calculate the revenue in 2018, 
the number of movie rentals and the number of active customers in 2018.*/

SELECT 
	SUM(m.renting_price), 
	COUNT(*), 
	COUNT(DISTINCT r.customer_id)
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id = m.movie_id
-- Only look at movie rentals in 2018
WHERE date_renting BETWEEN '2018-01-01'
AND '2018-12-31' ;

/*
You are asked to give an overview of which actors play in which movie.

Create a list of actor names and movie titles in which they act. 
Make sure that each combination of actor and movie appears only once.
Use as an alias for the table actsin the two letters ai.
*/

SELECT a.name, -- Create a list of movie titles and actor names
       m.title
FROM actsin AS ai
LEFT JOIN movies AS m
ON m.movie_id = ai.movie_id
LEFT JOIN actors AS a
ON a.actor_id = ai.actor_id;


/*
How much income did each movie generate?
*/
SELECT rm.title, -- Report the income from movie rentals for each movie 
       SUM(rm.renting_price) AS income_movie
FROM
       (SELECT m.title,  
               m.renting_price
       FROM renting AS r
       LEFT JOIN movies AS m
       ON r.movie_id=m.movie_id) AS rm
GROUP BY rm.title
ORDER BY income_movie DESC; -- Order the result by decreasing income

/*
 Report the date of birth of the oldest and youngest US actor and actress.
*/

SELECT a.gender, -- Report for male and female actors from the USA 
       MIN(a.year_of_birth), -- The year of birth of the oldest actor
       MAX(a.year_of_birth) -- The year of birth of the youngest actor
FROM
   (SELECT *  FROM actors -- Use a subsequen SELECT to get all information about actors from the USA
   WHERE nationality = 'USA'
   ) AS a -- Give the table the name a
GROUP BY a.gender;


/*
Which is the favorite movie on MovieNow? Answer this 
question for a specific group of customers: for all customers born in the 70s.
*/

SELECT m.title, 
COUNT(*),
AVG(r.rating)
FROM renting AS r
LEFT JOIN customers AS c
ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE c.date_of_birth BETWEEN '1970-01-01' AND '1979-12-31'
GROUP BY m.title
HAVING COUNT(*) > 1 -- Remove movies with only one rental
ORDER BY AVG(r.rating) DESC; -- Order with highest rating first

/*
Identify favorite actors for Spain
You're now going to explore actor popularity in Spain. 
Use as alias the first letter of the table, except for the table 
actsin use ai instead.
*/

--1. Augment the table renting with information about customers and actors.
SELECT *
FROM renting AS r 
LEFT JOIN customers AS c  -- Augment table renting with information about customers 
ON r.customer_id = c.customer_id
LEFT JOIN actsin AS ai  -- Augment the table renting with the table actsin
ON r.movie_id = ai.movie_id
LEFT JOIN actors AS a  -- Augment table renting with information about actors
ON a.actor_id = ai.actor_id;

/* 2
Report the number of movie rentals and the average rating for each actor, separately for male and female customers.
Report only actors with more than 5 movie rentals.
*/
SELECT a.name,  c.gender,
       COUNT(*) AS number_views, 
       AVG(r.rating) AS avg_rating
FROM renting as r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
LEFT JOIN actsin as ai
ON r.movie_id = ai.movie_id
LEFT JOIN actors as a
ON ai.actor_id = a.actor_id

GROUP BY a.name, c.gender -- For each actor, separately for male and female customers
HAVING AVG(r.rating) IS NOT NULL 
AND COUNT(*) > 5 -- Report only actors with more than 5 movie rentals
ORDER BY avg_rating DESC, number_views DESC;

/*
Augment the table renting with information about customers and movies.
Use as alias the first latter of the table name.
Select only records about rentals since beginning of 2019.
*/

SELECT *
FROM renting AS r -- Augment the table renting with information about customers
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
LEFT JOIN movies m -- Augment the table renting with information about movies
ON r.movie_id = m.movie_id
WHERE date_renting >= '2019-01-01'; -- Select only records about rentals since the beginning of 2019



/*
Augment the table renting with information about customers and movies.
Use as alias the first latter of the table name.
Select only records about rentals since beginning of 2019.
*/

SELECT *
FROM renting AS r -- Augment the table renting with information about customers
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
LEFT JOIN movies m -- Augment the table renting with information about movies
ON r.movie_id = m.movie_id
WHERE date_renting >= '2019-01-01'; -- Select only records about rentals since the beginning of 2019

/*
Calculate the number of movie rentals.
Calculate the average rating.
Calculate the revenue from movie rentals.
Report these KPIs for each country.
*/

SELECT 
	c.country,                    -- For each country report
	COUNT(*) AS number_renting, -- The number of movie rentals
	AVG(r.rating) AS average_rating, -- The average rating
	SUM(m.renting_price) AS revenue         -- The revenue from movie rentals
FROM renting AS r
LEFT JOIN customers AS c
ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE date_renting >= '2019-01-01'
GROUP BY c.country;

/* CHALLENGE
Often rented movies
Your manager wants you to make a list of movies 
excluding those which are hardly ever watched. This list of 
movies will be used for advertising. List all movies with 
more than 5 views using a nested query which is a 
powerful tool to implement selection conditions.
*/

-- First: Select all movie IDs which have more than 5 views.

SELECT movie_id, COUNT(*) -- Select movie IDs with more than 5 views
FROM renting
GROUP BY movie_id 
HAVING COUNT(*) > 5;

-- Second: Select all information about movies with more than 5 views.

SELECT *
FROM movies
WHERE movie_id IN  -- Select movie IDs from the inner query
	(SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(*) > 5)


/*
Frequent customers
Report a list of customers who frequently rent movies on MovieNow.

i,e List all customer information for customers who rented more than 10 movies.
*/

SELECT *
FROM customers
WHERE customer_id IN -- Select all customers with more than 10 movie rentals
	(SELECT customer_id
	FROM renting
	GROUP BY customer_id
	HAVING COUNT(*) > 10);


/*
Exercise
Movies with rating above average
For the advertising campaign your manager also needs a 
list of popular movies with high ratings. 
Report a list of movies with rating above average.
*/

-- First Calculate the average over all ratings.
SELECT -- Calculate the total average rating
AVG(rating)
FROM renting;

--Second; Select movie IDs and calculate the average rating of movies with rating above average.
SELECT movie_id, -- Select movie IDs and calculate the average rating 
       AVG(rating)
FROM renting
GROUP BY movie_id
HAVING AVG(rating) >           -- Of movies with rating above average
	(SELECT AVG(rating)
	FROM renting);

/* Third
The advertising team only wants a list of movie titles. 
Report the movie titles of all movies with average 
rating higher than the total average.
*/

SELECT title -- Report the movie titles of all movies with average rating higher than the total average
FROM movies
WHERE movie_id IN
	(SELECT movie_id
	 FROM renting
     GROUP BY movie_id
     HAVING AVG(rating) > 
		(SELECT AVG(rating)
		 FROM renting));


/*
  CORRELATED NESTED QUERIES
*/

-- No of movies rented more than 5 times
SELECT *
FROM movies AS m
WHERE 5 <
	(SELECT COUNT(*)
	   FROM renting AS r 
	WHERE r.movie_id = m.movie_id);  -- correlated queries

/*
Analyzing customer behavior
A new advertising campaign is going to focus on 
customers who rented fewer than 5 movies. 
Use a correlated query to extract all customer information for the 
customers of interest.

*/

-- Select customers with less than 5 movie rentals
SELECT *
FROM customers as c
WHERE 5 > 
	(SELECT count(*)
	FROM renting as r
	WHERE r.customer_id = c.customer_id);

/*
Customers who gave low ratings
Identify customers who were not satisfied with movies they 
watched on MovieNow. Report a list of customers with 
minimum rating smaller than 4.
*/

SELECT *
FROM customers AS c
WHERE 4 > -- Select all customers with a minimum rating smaller than 4 
	(SELECT MIN(rating)
	FROM renting AS r
	WHERE r.customer_id = c.customer_id);
	


/*
Movies and ratings with correlated queries
Report a list of movies that received the most attention on 
the movie platform, (i.e. report all movies with more than 5 
ratings and all movies with an average rating higher than 8).
*/

-- First: Select movies with more than 5 ratings
SELECT *
FROM movies AS m
WHERE 5 < -- Select all movies with more than 5 ratings
	(SELECT COUNT(rating)
	FROM renting AS r
	WHERE r.movie_id = m.movie_id);

-- Second: Select all movies with an average rating higher than 8.
SELECT *
FROM movies AS m
WHERE 8 < -- Select all movies with an average rating higher than 8
	(SELECT AVG(rating)
	FROM renting AS r
	WHERE r.movie_id = m.movie_id);

-- MOVIES WITH ATLEAST ONE RATING
SELECT *
FROM movies m
WHERE EXISTS
   (SELECT *
   FROM renting AS r
   WHERE rating IS NOT NULL 
   AND r.movie_id = m.movie_id);

/*
Customers with at least one rating
Having active customers is a key performance indicator 
for MovieNow. Make a list of customers who gave at least 
one rating.
*/

SELECT *
FROM customers AS c -- Select all customers with at least one rating
WHERE EXISTS
	(SELECT *
	FROM renting AS r
	WHERE rating IS NOT NULL 
	AND r.customer_id = c.customer_id);

/*
Actors in comedies
In order to analyze the diversity of actors in comedies, first, 
report a list of actors who play in comedies and then, the 
number of actors for each nationality playing in comedies.
*/

/*
Select the records of all actors who play in a Comedy. 
Use the first letter of the table as an alias.
*/
SELECT *  -- Select the records of all actors who play in a Comedy
FROM actsin AS ai
LEFT JOIN movies AS m
ON ai.movie_id = m.movie_id
WHERE m.genre = 'Comedy';

/*
Make a table of the records of actors who play in a 
Comedy and select only the actor with ID 1.
*/

SELECT *
FROM actsin AS ai
LEFT JOIN movies AS m
ON m.movie_id = ai.movie_id
WHERE m.genre = 'Comedy'
AND ai.actor_id = 1; -- Select only the actor with ID 1


/*
Create a list of all actors who play in a Comedy. 
Use the first letter of the table as an alias.
*/

SELECT *
FROM actors AS a
WHERE EXISTS
	(SELECT *
	 FROM actsin AS ai
	 LEFT JOIN movies AS m
	 ON m.movie_id = ai.movie_id
	 WHERE m.genre = 'Comedy'
	 AND ai.actor_id = a.actor_id);

/*
Report the nationality and the number of actors for each nationality.
*/

SELECT a.nationality, COUNT(*) -- Report the nationality and the number of actors for each nationality
FROM actors AS a
WHERE EXISTS
	(SELECT ai.actor_id
	 FROM actsin AS ai
	 LEFT JOIN movies AS m
	 ON m.movie_id = ai.movie_id
	 WHERE m.genre = 'Comedy'
	 AND ai.actor_id = a.actor_id)
GROUP BY a.nationality;


/*
  UNION

Young actors not coming from the USA
The operators UNION and INTERSECT are powerful tools when 
you work with two or more tables.

Identify actors who are not from the USA and actors who were born after 1990.
*/

-- First: Report the name, nationality and the year of birth of all actors who are not from the USA.

SELECT name,  -- Report the name, nationality and the year of birth
       year_of_birth, 
       nationality
FROM actors
WHERE nationality <> 'USA'; -- Of all actors who are not from the USA


-- Second: Report the name, nationality and the year of birth of all actors who were born after 1990.
SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE year_of_birth > 1990 ; -- Born after 1990

-- Third: Select all actors who are not from the USA and all actors who are born after 1990.
SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE nationality <> 'USA'
UNION -- Select all actors who are not from the USA and all actors who are born after 1990
SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE year_of_birth > 1990;

-- Fourth: Select all actors who are not from the USA and who are also born after 1990.

SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE nationality <> 'USA'
INTERSECT -- Select all actors who are not from the USA and who are also born after 1990
SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE year_of_birth > 1990;

/*
Dramas with high ratings
The advertising team has a new focus. They want to draw 
the attention of the customers to dramas. Make a list of all 
movies that are in the drama genre and have an average 
rating higher than 9.
*/

SELECT *
FROM movies
WHERE movie_id IN -- Select all movies of genre drama with average rating higher than 9
   (SELECT movie_id
    FROM movies
    WHERE genre = 'Drama'
    INTERSECT
    SELECT movie_id
    FROM renting
    GROUP BY movie_id
    HAVING AVG(rating)>9);
-------------------------------------------------------------------------------------------------------

/*
  OLAP: CUBE OPERATOR
  
  OLAP- On-line Analytical Processing 
  Aggregate data for a better overview
   - Count number of rentings for each customer
   - Average rating of movies for each genre and each country
  Produce pivot tables to present aggregation results
*/

SELECT country,
	   genre,
	   COUNT(*)
FROM renting_extended
GROUP BY CUBE (country, genre);

/*
Groups of customers
Use the CUBE operator to extract the content of a pivot 
table from the database. Create a table with the total 
number of male and female customers from each country.
*/

SELECT gender, -- Extract information of a pivot table of gender and country for the number of customers
	   country,
	   COUNT(*)
FROM customers
GROUP BY CUBE (gender, country)
ORDER BY country;


/*
Categories of movies
Give an overview on the movies available on MovieNow. 
List the number of movies for different genres and release years.
*/

SELECT genre,
       year_of_release,
       COUNT(*)
FROM movies
GROUP BY CUBE (genre, year_of_release)
ORDER BY year_of_release;


/*
Analyzing average ratings
Prepare a table for a report about the national preferences 
of the customers from MovieNow comparing the average rating of 
movies across countries and genres.
*/

-- Frist
-- Augment the records of movie rentals with information about movies and customers
SELECT *
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id = m.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id;

-- Second
-- Calculate the average rating for each country.
SELECT 
	country,
    AVG(rating)
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY country;

-- Third
-- Calculate the average rating for all aggregation levels of country and genre.

SELECT 
	country, 
	genre, 
	AVG(r.rating) AS avg_rating -- Calculate the average rating 
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY CUBE (country, genre); -- For all aggregation levels of country and genre

---------------------------------------------------------------
/*
OLAP - ROLLUP 
- Returns aggregate for hierachy of values 
*/

SELECT country,
	   genre,
	   COUNT(*)
FROM renting_extended
GROUP BY ROLLUP (country, genre);

/*
Number of customers
You have to give an overview of the number of customers 
for a presentation.
*/

/*

Generate a table with the total number of customers, the number of customers for each country, and the number of female and male customers for each country.
Order the result by country and gender.

*/
-- Count the total number of customers, the number of customers for each country, and the number of female and male customers for each country
SELECT country,
       gender,
	   COUNT(*)
FROM customers
GROUP BY ROLLUP (country, gender)
ORDER BY country, gender; -- Order the result by country and gender

/*

Analyzing preferences of genres across countries
You are asked to study the preferences of genres across 
countries. Are there particular genres which are more 
popular in specific countries? Evaluate the preferences of 
customers by averaging their ratings and counting the 
number of movies rented from each genre.

*/

-- First
-- Augment the renting records with information about movies and customers.
-- Join the tables
SELECT *
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id = m.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id;
-- Second
/*Calculate the average ratings and the number of ratings for each country and each genre. 
Include the columns country and genre in the SELECT clause.*/
SELECT 
	c.country, -- Select country
	m.genre, -- Select genre
	AVG(r.rating), -- Average ratings
	COUNT(*)  -- Count number of movie rentals
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY ROLLUP(c.country, m.genre) -- Aggregate for each country and each genre
ORDER BY c.country, m.genre;

/*Third
Finally, calculate the average ratings and the number 
of ratings for each country and genre, as well as an 
aggregation over all genres for each country and the 
overall average and total number.
*/

-- Group by each county and genre with OLAP extension
SELECT 
	c.country, 
	m.genre, 
	AVG(r.rating) AS avg_rating, 
	COUNT(*) AS num_rating
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY ROLLUP(c.country, m.genre)
ORDER BY c.country, m.genre;

---------------------------------------------------------------
/*
OLAP - GROUPING SET OPERATORS
-
e.g
SELECT country, genre, COUNT(*)
FROM rentings_extended
GROUP BY GROUPING SETS ((country, genre), (country), (genre), ());

- column names above surrounded by brackets represen one level of aggregation.
Hence the above represent 4 different levels of aggregations
- Group by Grouping sets returns a UNION over several GROUP BY queries
- Combine all information of a pivot table in one query
- The query is similar to GROUP BY CUBE (country, genre)
*/


/*
Exploring nationality and gender of actors
For each movie in the database, the three most important 
actors are identified and listed in the table actors. This 
table includes the nationality and gender of the actors. 
We are interested in how much diversity there is in the 
nationalities of the actors and how many actors and actresses are in the list.
*/

-- Challenge
-- Count the number of actors in the table actors from each country, the number of male and female actors and the total number of actors.

SELECT 
	nationality, -- Select nationality of the actors
    gender, -- Select gender of the actors
    COUNT(*) -- Count the number of actors
FROM actors
GROUP BY GROUPING SETS ((nationality), (gender), ()); -- Use the correct GROUPING SETS operation

/*
Exploring rating by country and gender
Now you will investigate the average rating of customers aggregated by country and gender.
*/

-- Step 1
/*
Select the columns country, gender, and rating and 
use the correct join to combine the table renting with customer.
*/
SELECT 
	c.country, -- Select country, gender and rating
    c.gender,
    r.rating
FROM renting AS r
LEFT JOIN customers AS c -- Use the correct join
ON r.customer_id = c.customer_id;

-- Step 2
/*
Use GROUP BY to calculate the average rating over 
country and gender. Order the table by country and gender.
*/
SELECT 
	c.country, 
    c.gender,
	AVG(rating) -- Calculate average rating
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY c.country, c.gender -- Order and group by country and gender
ORDER BY c.country,c.gender;

-- Step 3
/*
Now, use GROUPING SETS to get the same result, i.e. the 
average rating over country and gender.
*/
SELECT 
	c.country, 
    c.gender,
	AVG(r.rating)
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY GROUPING SETS ((country,gender)); -- Group by country and gender with GROUPING SETS

-- Step 4
/*
Report all information that is included in a pivot table 
for country and gender in one SQL table.
*/
SELECT 
	c.country, 
    c.gender,
	AVG(r.rating)
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
-- Report all info from a Pivot table for country and gender
GROUP BY GROUPING SETS ((country, gender), (country), (gender), ());


-- challenge
SELECT c.country,
	   m.year_of_release,
	   COUNT(*),
	   COUNT(DISTINCT r.movie_id) AS n_movies,
	   AVG(rating) AS avg_rating
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
LEFT JOIN movies AS m
ON r.movie_id = m.movie_id
WHERE r.movie_id IN (
	SELECT movie_id,
	FROM renting 
	GROUP BY movie_id
	HAVING COUNT(rating) >= 4)
AND r.date_renting >= '2018-04-01'
GROUP BY ROLLUP ( m.year_of_release, c.country)
ORDER BY c.country, m.year_of_release;

/*
Customer preference for genres
You just saw that customers have no clear preference for 
more recent movies over older ones. Now the management 
considers investing money in movies of the best rated genres.
*/

SELECT genre,
	   AVG(rating) AS avg_rating,
	   COUNT(rating) AS n_rating,
       COUNT(*) AS n_rentals,     
	   COUNT(DISTINCT m.movie_id) AS n_movies 
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(rating) >= 3 )
AND r.date_renting >= '2018-01-01'
GROUP BY genre
ORDER BY avg_rating DESC; -- Order the table by decreasing average rating

/*
Customer preference for actors

The last aspect you have to analyze are customer 
preferences for certain actors.
*/

/*STEP1
For each combination of the actors' nationality and 
gender, calculate the average rating, the number of 
ratings, the number of movie rentals, and the number of actors.*/
SELECT a.nationality,
       a.gender,
	   AVG(r.rating) AS avg_rating, -- The average rating
	   COUNT(r.rating) AS n_rating, -- The number of ratings
	   COUNT(*) AS n_rentals, -- The number of movie rentals
	   COUNT(DISTINCT a.actor_id) AS n_actors -- The number of actors
FROM renting AS r
LEFT JOIN actsin AS ai
ON ai.movie_id = r.movie_id
LEFT JOIN actors AS a
ON ai.actor_id = a.actor_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(rating) >=4 )
AND r.date_renting >= '2018-04-01'
GROUP BY a.nationality, a.gender; -- Report results for each combination of the actors' nationality and gender

/*STEP1
Provide results for all aggregation levels represented in a pivot table.*/
SELECT a.nationality,
       a.gender,
	   AVG(r.rating) AS avg_rating,
	   COUNT(r.rating) AS n_rating,
	   COUNT(*) AS n_rentals,
	   COUNT(DISTINCT a.actor_id) AS n_actors
FROM renting AS r
LEFT JOIN actsin AS ai
ON ai.movie_id = r.movie_id
LEFT JOIN actors AS a
ON ai.actor_id = a.actor_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(rating) >= 4)
AND r.date_renting >= '2018-04-01'
GROUP BY CUBE(a.nationality, a.gender); -- Provide results for all aggregation levels represented in a pivot table