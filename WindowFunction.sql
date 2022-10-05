/*
How can you view stations with total trips lower than average using a nested subquery 
*/
SELECT
 start_station,
 COUNT(*) AS trips
FROM trip
GROUP BY start_station
HAVING COUNT(*) < 
  (SELECT AVG(tr)
   FROM (
     SELECT start_station,
	   COUNT(*) AS tr
	   FROM trip
     GROUP BY start_station
   ) AS subquery )
LIMIT 5;



SELECT id, date,
CASE WHEN h_goal > a_goal THEN 'Home Win'
    WHEN h_goal = a_goal THEN 'Tie'
    WHEN h_goal < a_goal THEN
 a_goal - h_goal < 2 THEN '<2'
CASE WHEN a_goal - h_goal >= 2 THEN '2+' 
END END AS diff
FROM matches
LIMIT 5;


SELECT
 l.name AS league,
 m.date,
 m.home_goal,
 m.away_goal
FROM league AS l
 INNER JOIN
  (SELECT country_id, date, home_goal, away_goal
   FROM match
   WHERE home_goal > away_goal+5) AS m
 ON l.id = m.country_id
LIMIT 5;


/*
	The players table in the database includes data on each player's height. 
	How would you categorize them as above or below average in SQL? 
*/

SELECT player_name,
 CASE WHEN height <= 178 THEN 'Below avg'
 ELSE 'Above avg' END AS height_cat
FROM players
LIMIT 5;

/*
Use a window function to calculate a partitioned average bicycle trip duration
by start_station and sub_type? */ 

SELECT
  start_station,
  sub_type,
  duration,
 AVG(duration) OVER(PARTITION BY start_station, sub_type )AS duration_avg
FROM trips
ORDER BY duration
LIMIT 5;

/*
	Numbering rows
The simplest application for window functions is numbering rows. 
Numbering rows allows you to easily fetch the nth row. 
For example, it would be very difficult to get the 35th row in any given table if you didn't have a column with each row's number.
	*/

-- Number each row in the dataset.
SELECT
  *,
  -- Assign numbers to each row
  ROW_NUMBER () OVER() AS Row_N
FROM Summer_Medals
ORDER BY Row_N ASC;


/*
	Assign a number to each year in which Summer Olympic games were held.
*/

SELECT
  Year,
  -- Assign numbers to each year
  ROW_NUMBER() OVER() AS Row_N
FROM (
  SELECT DISTINCT year
  FROM Summer_Medals
  ORDER BY Year ASC
) AS Years
ORDER BY Year ASC;

/*
	 Assign a number to each year in which Summer Olympic games were held 
 	so that rows with the most recent years have lower row numbers. 
*/

SELECT
  Year,
  -- Assign the lowest numbers to the most recent years
  ROW_NUMBER() OVER (ORDER BY years DESC) AS Row_N
FROM (
  SELECT DISTINCT Year
  FROM Summer_Medals
) AS Years
ORDER BY Year;


/*
Assign a number to each year in which Summer 
Olympic games were held so that rows with the most recent years have lower row numbers.
rank each athlete by the number of medals they've earned.
*/

WITH Athlete_Medals AS (
  SELECT
    -- Count the number of medals each athlete has earned
    Athlete,
    COUNT(*) AS Medals
  FROM Summer_Medals
  GROUP BY Athlete)

SELECT
  -- Number each athlete by how many medals they've earned
  athlete,
  ROW_NUMBER() OVER (ORDER BY Medals DESC) AS Row_N
FROM Athlete_Medals
ORDER BY Medals DESC;



/*
CHALLENGE
Return each year's gold medalists in the Men's 69KG weightlifting competition.
*/

SELECT
  -- Return each year's champions' countries
  year,
  country AS champion
FROM Summer_Medals
WHERE
  Discipline = 'Weightlifting' AND
  Event = '69KG' AND
  Gender = 'Men' AND
  Medal = 'Gold';
  
  
  /* CHALLENGE
  Having wrapped the previous query in the Weightlifting_Gold CTE, 
  get the previous year's champion for each year.
  */
  -- This can happen with the help of LAG Window function
  
  WITH Weightlifting_Gold AS (
  SELECT
    -- Return each year's champions' countries
    Year,
    Country AS champion
  FROM Summer_Medals
  WHERE
    Discipline = 'Weightlifting' AND
    Event = '69KG' AND
    Gender = 'Men' AND
    Medal = 'Gold')

SELECT
  Year, Champion,
  -- Fetch the previous year's champion
  LAG(Champion, 1) OVER
    (ORDER BY year ASC) AS Last_Champion
FROM Weightlifting_Gold
ORDER BY Year ASC;


/* CHALLENGE
Return the previous champions of each year's event by gender.
*/

WITH Tennis_Gold AS (
  SELECT DISTINCT
    Gender, Year, Country
  FROM Summer_Medals
  WHERE
    Year >= 2000 AND
    Event = 'Javelin Throw' AND
    Medal = 'Gold')

SELECT
  Gender, Year,
  Country AS Champion,
  -- Fetch the previous year's champion by gender
  LAG(Country) OVER (PARTITION BY gender
            ORDER BY gender ASC) AS Last_Champion
FROM Tennis_Gold
ORDER BY Gender ASC, Year ASC;

/* CHALLENGE
Return the previous champions of each year's events by gender and event.
*/

WITH Athletics_Gold AS (
  SELECT DISTINCT
    Gender, Year, Event, Country
  FROM Summer_Medals
  WHERE
    Year >= 2000 AND
    Discipline = 'Athletics' AND
    Event IN ('100M', '10000M') AND
    Medal = 'Gold')

SELECT
  Gender, Year, Event,
  Country AS Champion,
  -- Fetch the previous year's champion by gender and event
  LAG(Country) OVER (PARTITION BY gender, event
            ORDER BY Year ASC) AS Last_Champion
FROM Athletics_Gold
ORDER BY Event ASC, Gender ASC, Year ASC;


/*
For each year, fetch the current gold medalist and 
the gold medalist 3 competitions ahead of the current row.
*/

WITH Discus_Medalists AS (
  SELECT DISTINCT
    Year,
    Athlete
  FROM Summer_Medals
  WHERE Medal = 'Gold'
    AND Event = 'Discus Throw'
    AND Gender = 'Women'
    AND Year >= 2000)

SELECT
  -- For each year, fetch the current and future medalists
  year,
  Athlete,
  LEAD(Athlete, 3) OVER (ORDER BY year ASC) AS Future_Champion
FROM Discus_Medalists
ORDER BY Year ASC;


/* CHALLENGE
Return all athletes and the first athlete ordered by alphabetical order.
*/

WITH All_Male_Medalists AS (
  SELECT DISTINCT
    Athlete
  FROM Summer_Medals
  WHERE Medal = 'Gold'
    AND Gender = 'Men')

SELECT
  -- Fetch all athletes and the first athlete alphabetically
  Athlete,
  FIRST_VALUE(athlete) OVER (
    ORDER BY Athlete ASC
  ) AS First_Athlete
FROM All_Male_Medalists;


/* CHALLENGE
Return the year and the city in which each Olympic games were held.
Fetch the last city in which the Olympic games were held.
*/

WITH Hosts AS (
  SELECT DISTINCT Year, City
    FROM Summer_Medals)

SELECT
  Year,
  City,
  -- Get the last city in which the Olympic games were held
  LAST_VALUE(city) OVER (
   ORDER BY Year ASC
   RANGE BETWEEN
     UNBOUNDED PRECEDING AND
     UNBOUNDED FOLLOWING
  ) AS Last_City
FROM Hosts
ORDER BY Year ASC;

/* CHALLENGE
Rank each athlete by the number of medals they've earned 
-- the higher the count, the higher the rank 
-- with identical numbers in case of identical values.
*/

WITH Athlete_Medals AS (
  SELECT
    Athlete,
    COUNT(*) AS Medals
  FROM Summer_Medals
  GROUP BY Athlete)

SELECT
  Athlete,
  Medals,
  -- Rank athletes by the medals they've won
  RANK() OVER (ORDER BY Medals DESC) AS Rank_N
FROM Athlete_Medals
ORDER BY Medals DESC;

/* CHALLENGE
Rank each country's athletes by the count of medals they've earned 
-- the higher the count, the higher the rank 
-- without skipping numbers in case of identical values.
*/

WITH Athlete_Medals AS (
  SELECT
    Country, Athlete, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country IN ('JPN', 'KOR')
    AND Year >= 2000
  GROUP BY Country, Athlete
  HAVING COUNT(*) > 1)

SELECT
  Country,
  -- Rank athletes in each country by the medals they've won
  athlete,
  DENSE_RANK() OVER (PARTITION BY country
                ORDER BY Medals DESC) AS Rank_N
FROM Athlete_Medals
ORDER BY Country ASC, RANK_N ASC;

/* CHALLENGE - PAGING
Split the distinct events into exactly 111 groups,
ordered by event in alphabetical order.
*/

WITH Events AS (
  SELECT DISTINCT Event
  FROM Summer_Medals)
  
SELECT
  --- Split up the distinct events into 111 unique groups
  event,
  NTILE(111) OVER (ORDER BY event ASC) AS Page
FROM Events
ORDER BY Event ASC;


/* CHALLENGE - PAGING
Split the athletes into top, middle, 
and bottom thirds based on their count of medals.
*/

WITH Athlete_Medals AS (
  SELECT Athlete, COUNT(*) AS Medals
  FROM Summer_Medals
  GROUP BY Athlete
  HAVING COUNT(*) > 1)
  
SELECT
  Athlete,
  Medals,
  -- Split athletes into thirds by their earned medals
  NTILE(3) OVER(ORDER BY medals DESC) AS Third
FROM Athlete_Medals
ORDER BY Medals DESC, Athlete ASC;

/* CHALLENGE - PAGING
Split the athletes into top, middle, 
and bottom thirds based on their count of medals.
RETURN THE AVERAGE OF EACH THIRD
*/

WITH Athlete_Medals AS (
  SELECT Athlete, COUNT(*) AS Medals
  FROM Summer_Medals
  GROUP BY Athlete
  HAVING COUNT(*) > 1),
  
  Thirds AS (
  SELECT
    Athlete,
    Medals,
    NTILE(3) OVER (ORDER BY Medals DESC) AS Third
  FROM Athlete_Medals)
  
SELECT
  -- Get the average medals earned in each third
  Third,
  AVG(medals) AS Avg_Medals
FROM Thirds
GROUP BY Third
ORDER BY Third ASC;


/* CHALLENGE - AGGREGATE FUNCTN
Return the athletes, the number of medals they earned, 
and the medals running total, 
ordered by the athletes' names in alphabetical order.
*/

WITH Athlete_Medals AS (
  SELECT
    Athlete, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country = 'USA' AND Medal = 'Gold'
    AND Year >= 2000
  GROUP BY Athlete)

SELECT
  -- Calculate the running total of athlete medals
  Athlete,
  Medals,
  SUM(Medals) OVER (ORDER BY Athlete ASC) AS Max_Medals
FROM Athlete_Medals
ORDER BY Athlete ASC;


/* CHALLENGE - AGGREGATE FUNCTN
Return the year, country, medals, and the maximum medals earned so far for each country, 
ordered by year in ascending order.
*/

WITH Country_Medals AS (
  SELECT
    Year, Country, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country IN ('CHN', 'KOR', 'JPN')
    AND Medal = 'Gold' AND Year >= 2000
  GROUP BY Year, Country)

SELECT
  -- Return the max medals earned so far per country
  Year,
  country,
  medals,
  MAX(medals) OVER (PARTITION BY country
                ORDER BY Year ASC) AS Max_Medals
FROM Country_Medals
ORDER BY Country ASC, Year ASC;

/* CHALLENGE - AGGREGATE FUNCTN
Return the year, medals earned, and minimum medals earned so far.
*/

WITH France_Medals AS (
  SELECT
    Year, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country = 'FRA'
    AND Medal = 'Gold' AND Year >= 2000
  GROUP BY Year)

SELECT
  year,
  Medals,
  MIN(Medals) OVER (ORDER BY year ASC) AS Min_Medals
FROM France_Medals
ORDER BY Year ASC;


/* CHALLENGE - FRAME FUNCTN
Return the year, medals earned, and the maximum medals earned, 
comparing only the current year and the next year.
*/

WITH Scandinavian_Medals AS (
  SELECT
    Year, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country IN ('DEN', 'NOR', 'FIN', 'SWE', 'ISL')
    AND Medal = 'Gold'
  GROUP BY Year)

SELECT
  -- Select each year's medals
  year,
  medals,
  -- Get the max of the current and next years'  medals
  MAX(Medals) OVER (ORDER BY year ASC
             ROWS BETWEEN CURRENT ROW
             AND 1 FOLLOWING) AS Max_Medals
FROM Scandinavian_Medals
ORDER BY Year ASC;

/* CHALLENGE - FRAME FUNCTN
Return the athletes, medals earned, and the maximum medals earned, 
comparing only the last two and current athletes, 
ordering by athletes' names in alphabetical order.
*/

WITH Chinese_Medals AS (
  SELECT
    Athlete, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country = 'CHN' AND Medal = 'Gold'
    AND Year >= 2000
  GROUP BY Athlete)

SELECT
  -- Select the athletes and the medals they've earned
  athlete,
  medals,
  -- Get the max of the last two and current rows' medals 
  MAX(medals) OVER (ORDER BY athlete ASC
            ROWS BETWEEN 2 PRECEDING
            AND CURRENT ROW) AS Max_Medals
FROM Chinese_Medals
ORDER BY Athlete ASC;


/* CHALLENGE - MOVING AVERAGE
Calculate the 3-year moving average of medals earned.
*/
WITH Russian_Medals AS (
  SELECT
    Year, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country = 'RUS'
    AND Medal = 'Gold'
    AND Year >= 1980
  GROUP BY Year)

SELECT
  Year, Medals,
  --- Calculate the 3-year moving average of medals earned
  AVG(medals) OVER
    (ORDER BY Year ASC
     ROWS BETWEEN
     2 PRECEDING AND CURRENT ROW) AS Medals_MA
FROM Russian_Medals
ORDER BY Year ASC;

/* CHALLENGE - MOVING SUM
Calculate the 3-year moving sum of medals earned per country.
*/

WITH Country_Medals AS (
  SELECT
    Year, Country, COUNT(*) AS Medals
  FROM Summer_Medals
  GROUP BY Year, Country)

SELECT
  Year, Country, Medals,
  -- Calculate each country's 3-game moving total
  SUM(Medals) OVER
    (PARTITION BY country
     ORDER BY Year ASC
     ROWS BETWEEN
     2 PRECEDING AND CURRENT ROW) AS Medals_MA
FROM Country_Medals
ORDER BY Country ASC, Year ASC;


/* CHALLENGE - PIVOT TABLE
Pivot by year
*/

-- Create the correct extention to enable CROSSTAB
CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT * FROM CROSSTAB($$
  SELECT
    Gender, Year, Country
  FROM Summer_Medals
  WHERE
    Year IN (2008, 2012)
    AND Medal = 'Gold'
    AND Event = 'Pole Vault'
  ORDER By Gender ASC, Year ASC;
-- Fill in the correct column names for the pivoted table
$$) AS ct (Gender VARCHAR,
           "2018" VARCHAR,
           "2012" VARCHAR)

ORDER BY Gender ASC;


-- ANOTHER PIVOT BY YEAR TO CHANGE THE STRUCTURE OF THE OUTPUT
CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT * FROM CROSSTAB($$
  WITH Country_Awards AS (
    SELECT
      Country,
      Year,
      COUNT(*) AS Awards
    FROM Summer_Medals
    WHERE
      Country IN ('FRA', 'GBR', 'GER')
      AND Year IN (2004, 2008, 2012)
      AND Medal = 'Gold'
    GROUP BY Country, Year)

  SELECT
    Country,
    Year,
    RANK() OVER
      (PARTITION BY Year
       ORDER BY Awards DESC) :: INTEGER AS rank
  FROM Country_Awards
  ORDER BY Country ASC, Year ASC;
-- Fill in the correct column names for the pivoted table
$$) AS ct (Country VARCHAR,
           "2004" INTEGER,
           "2008" INTEGER,
           "2012" INTEGER)
Order by Country ASC;



-- ROLLUP FUNCTION
-- Count the gold medals per country and gender
SELECT
  country,
  gender,
  COUNT(*) AS Gold_Awards
FROM Summer_Medals
WHERE
  Year = 2004
  AND Medal = 'Gold'
  AND Country IN ('DEN', 'NOR', 'SWE')
-- Generate Country-level subtotals
GROUP BY country, ROLLUP(Gender)
ORDER BY Country ASC, Gender ASC;


--CUBE FOR GROUPING WITH SUB TOTALS
-- Count the medals per gender and medal type
SELECT
  gender,
  Medal,
  COUNT(*) AS Awards
FROM Summer_Medals
WHERE
  Year = 2012
  AND Country = 'RUS'
-- Get all possible group-level subtotals
GROUP BY CUBE(Gender, Medal)
ORDER BY Gender ASC, Medal ASC;


-- - CLEANING RESULT WITH COALESCE AND STRING_AGG
SELECT
  -- Replace the nulls in the columns with meaningful text
  COALESCE(Country, 'All countries') AS Country,
  COALESCE(Gender, 'All genders') AS Gender,
  COUNT(*) AS Awards
FROM Summer_Medals
WHERE
  Year = 2004
  AND Medal = 'Gold'
  AND Country IN ('DEN', 'NOR', 'SWE')
GROUP BY ROLLUP(Country, Gender)
ORDER BY Country ASC, Gender ASC;

-- STRING_AGG FUNCTION WITH RANK

WITH Country_Medals AS (
  SELECT
    Country,
    COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE Year = 2000
    AND Medal = 'Gold'
  GROUP BY Country),

  Country_Ranks AS (
  SELECT
    Country,
    RANK() OVER (ORDER BY Medals DESC) AS Rank
  FROM Country_Medals
  ORDER BY Rank ASC)

-- Compress the countries column
SELECT STRING_AGG(Country, ', ')
FROM Country_Ranks
-- Select only the top three ranks
WHERE Rank <= 3;