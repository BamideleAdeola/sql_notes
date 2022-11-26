/* Write your T-SQL query statement below */

--1 Write an SQL query to report the first login date for each player.
SELECT player_id, MIN(event_date) AS first_login
FROM Activity
GROUP BY player_id;


--Query a list of CITY names from STATION for cities that have an even ID number. Print the results in any order, but exclude duplicates from the answer.
SELECT CITY FROM STATION
WHERE ID % 2 = 0 -- remainder 0 for even numbers
GROUP BY CITY; -- To remove duplicates


--Find the difference between the total number of CITY entries in the table and the number of distinct CITY entries in the table.
--The STATION table is described as follows:

SELECT COUNT(CITY) - COUNT(DISTINCT CITY)
FROM STATION;


/*7. Query the two cities in STATION with the shortest and longest CITY names, as well as 
their respective lengths (i.e.: number of characters in the name). If there is more 
than one smallest or largest city, choose the one that comes first when ordered alphabetically.
*/

SELECT TOP (1) CITY, LEN(CITY)
FROM STATION
ORDER BY LEN(CITY) ASC, CITY;

SELECT TOP (1) CITY, LEN(CITY)
FROM STATION
ORDER BY LEN(CITY) DESC, CITY;


--8. Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result cannot contain duplicates.

SELECT DISTINCT CITY
FROM STATION
WHERE CITY LIKE '[a,e,i,o,u]%';

SELECT DISTINCT CITY
FROM STATION
WHERE LEFT (CITY, 1) IN ('a','e','i','o','u');

SELECT DISTINCT CITY
FROM STATION
WHERE SUBSTRING(CITY,1, 1) IN ('a','e','i','o','u');


--9. Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot contain duplicates.
SELECT DISTINCT CITY
FROM STATION
WHERE CITY LIKE '%[a,e,i,o,u]';

SELECT DISTINCT CITY
FROM STATION
WHERE RIGHT(CITY,1) IN ('a', 'e', 'i', 'o', 'u') ;


/* 10. Query the list of CITY names from STATION which have vowels (i.e., a, e, i, o, and u) 
as both their first and last characters. Your result cannot contain duplicates. */

SELECT DISTINCT CITY 
FROM STATION
WHERE CITY LIKE '[a,e,i,o,u]%' AND CITY LIKE '%[a,e,i,o,u]';

/* 11. Query the list of CITY names from STATION that do not start with vowels. 
Your result cannot contain duplicates.
*/

SELECT DISTINCT CITY
FROM STATION
WHERE CITY NOT LIKE '[a, e, i, o, u]%';

/* 12. Query the list of CITY names from STATION that do not END with vowels. 
Your result cannot contain duplicates.
*/
SELECT DISTINCT CITY
FROM STATION
WHERE CITY NOT LIKE '%[a, e, i, o, u]';

----------
--BADGE 3
----------

/* Weather Observation Station 11
Query the list of CITY names from STATION that either do not start with vowels 
or do not end with vowels. Your result cannot contain duplicates.
*/

SELECT DISTINCT CITY
FROM STATION
WHERE CITY NOT LIKE '[a, e, i, o, u]%'
OR CITY NOT LIKE '%[a, e, i, o, u]';

/* Weather Observation Station 12
Query the list of CITY names from STATION that do not start with vowels 
AND do not end with vowels. Your result cannot contain duplicates.
*/
SELECT DISTINCT CITY
FROM STATION
WHERE CITY NOT LIKE '[a, e, i, o, u]%'
AND CITY NOT LIKE '%[a, e, i, o, u]';


/*
--Higher Than 75 Marks
Query the Name of any student in STUDENTS who scored higher than  Marks. 
Order your output by the last three characters of each name. If two or 
more students both have names ending in the same last three characters 
(i.e.: Bobby, Robby, etc.), secondary sort them by ascending ID.
*/

SELECT Name 
FROM Students
WHERE Marks > 75
ORDER BY RIGHT(Name, 3), ID ASC;

/*
--EmployeeNames
Write a query that prints a list of employee names (i.e.: the name attribute) 
from the Employee table in alphabetical order.
*/

SELECT name
FROM Employee
ORDER BY name;


/* Employee Salaries
Write a query that prints a list of employee names 
(i.e.: the name attribute) for employees in Employee having a salary 
greater than 2000 per month who have been employees for less than  months. 
Sort your result by ascending employee_id.
*/
SELECT name
FROM Employee
WHERE salary > 2000
AND months < 10
ORDER BY employee_id;


-----
--Query the average population of all cities in CITY where District is California.
SELECT AVG(POPULATION)
FROM CITY
WHERE DISTRICT = 'California';

--Query the average population for all cities in CITY, rounded down to the nearest integer.
SELECT ROUND(AVG(POPULATION),0)
FROM CITY;


/*Query the sum of the populations for all Japanese cities in CITY. 
The COUNTRYCODE for Japan is JPN. */

SELECT SUM(POPULATION)
FROM CITY 
WHERE COUNTRYCODE = 'JPN';

--Query the difference between the maximum and minimum populations in CITY.
SELECT MAX(POPULATION) - MIN(POPULATION)
FROM CITY

--------------
-- THE BLUNDER
--------------

/* Samantha was tasked with calculating the average monthly salaries 
for all employees in the EMPLOYEES table, but did not realize her 
keyboard's  key was broken until after completing the calculation. 
She wants your help finding the difference between her miscalculation 
(using salaries with any zeros removed), and the actual average salary.

Write a query calculating the amount of error (i.e.:  average monthly salaries), 
and round it up to the next integer.
*/

SELECT 
 CAST(CEILING(AVG(CAST (Salary AS FLOAT)) - AVG(CAST(REPLACE(salary, '0', '') AS FLOAT))) AS INT)
FROM EMPLOYEES


--------------
-- TOP EARBERS
--------------

/* 
We define an employee's total earnings to be their monthly  worked, 
and the maximum total earnings to be the maximum total earnings for any 
employee in the Employee table. Write a query to find the maximum total 
earnings for all employees as well as the total number of employees who have 
maximum total earnings. Then print these values as  space-separated integers.
*/

select concat((select max(months*salary) from employee), ' ',
              (select count(*) from
               (select rank() over (order by months*salary desc) as  
 
                 rnk from employee) t where t.rnk = 1)
               );

SELECT TOP(1) salary*months as earnings,
COUNT(*) FROM Employee
GROUP BY salary*months
ORDER BY earnings DESC;

--------------------------------
/* Weather Observation Station 2
--------------------------------
Query the following two values from the STATION table:

The sum of all values in LAT_N rounded to a scale of 2 decimal places.
The sum of all values in LONG_W rounded to a scale of 2 decimal places.
*/

SELECT 
  CAST(ROUND(SUM(LAT_N),2) AS DECIMAL(10,2)) AS lat ,
  CAST(ROUND(SUM(LONG_W),2) AS DECIMAL(10,2)) AS lon 
FROM STATION;


/*-------------------------------
Weather Observation Station 13
--------------------------------
Query the sum of Northern Latitudes (LAT_N) from STATION having values greater
than 38.7880 and less than 137.2345 . Truncate your answer to 4 decimal places.
*/

SELECT CAST(SUM(LAT_N)AS DECIMAL(10,4))
FROM STATION
WHERE LAT_N > 38.7880
AND LAT_N < 137.2345;


/*
Query the greatest value of the Northern Latitudes (LAT_N) 
from STATION that is less than 137.2345 . Truncate your answer to 4 decimal places.
*/

SELECT CAST(MAX(LAT_N) AS DECIMAL(10,4))
FROM STATION
WHERE LAT_N < 137.2345;


/* Weather Observation Station 15
Query the Western Longitude (LONG_W) for the largest Northern Latitude 
(LAT_N) in STATION that is less than 137.2345 . Round your answer to 4 decimal places.
*/

SELECT CAST(LONG_W AS DECIMAL(10,4))
FROM STATION
WHERE LAT_N = (SELECT MAX(LAT_N) FROM STATION WHERE LAT_N < 137.2345);


/* Weather Observation Station 16
Query the smallest Northern Latitude (LAT_N) from STATION that is greater than 38.7780. 
Round your answer to 4 decimal places.
*/

SELECT CAST(MIN(LAT_N) AS DECIMAL(10,4))
FROM STATION
WHERE LAT_N > 38.7780;


/* Weather Observation Station 17
Query the Western Longitude (LONG_W) where the smallest Northern Latitude 
(LAT_N) in STATION is greater than 38.7780 . Round your answer to  decimal places.
*/

SELECT CAST(LONG_W AS DECIMAL(10,4))
FROM STATION
WHERE LAT_N = (SELECT MIN(LAT_N) FROM STATION 
              WHERE LAT_N > 38.7780);


/*
Consider P1(a,b)  and P2(c,d) to be two points on a 2D plane.

 happens to equal the minimum value in Northern Latitude (LAT_N in STATION).
 happens to equal the minimum value in Western Longitude (LONG_W in STATION).
 happens to equal the maximum value in Northern Latitude (LAT_N in STATION).
 happens to equal the maximum value in Western Longitude (LONG_W in STATION).
Query the Manhattan Distance between points  and  and round it to a scale of  decimal places.
*/

WITH CTE(A, B, C, D) AS
(
    SELECT 
      MIN(LAT_N),
      MIN(LONG_W),
      MAX(LAT_N),
      MAX(LONG_W)
    FROM STATION
)

SELECT CAST(ABS(A - C) + ABS(B - D) AS DECIMAL(10,4))
FROM CTE;


/*
Consider P1(a,c) and P2(b,d) to be two points on a 2D plane where (a,b) are the respective minimum 
and maximum values of Northern Latitude (LAT_N) and (c,d) are the respective minimum 
and maximum values of Western Longitude (LONG_W) in STATION.

Query the Euclidean Distance between points  and  and format your 
answer to display  decimal digits.
*/

WITH CTE(A, B, C, D) AS
(
    SELECT 
      MIN(LAT_N),
      MIN(LONG_W),
      MAX(LAT_N),
      MAX(LONG_W)
    FROM STATION
)
SELECT CAST (SQRT(SQUARE(C-A) + SQUARE(D-B)) AS DECIMAL(10,4))
FROM CTE;


-------------
-- BADGE 5
------------

/*
A median is defined as a number separating the higher half of a data 
set from the lower half. Query the median of the Northern Latitudes (LAT_N) 
from STATION and round your answer to 4 decimal places.
*/

SELECT TOP 1
  CAST(PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY LAT_N) 
       OVER() AS DECIMAL(10,4))
FROM STATION
ORDER BY LAT_N;


/*
Query a count of the number of cities in CITY having a Population larger than 100000.
*/

SELECT COUNT(*)
FROM CITY
WHERE POPULATION > 100000;


--Query the total population of all cities in CITY where District is California.

SELECT SUM(POPULATION)
FROM CITY
WHERE DISTRICT = 'California';


-------------------------------
/* Type of Triangle
-----------------------------------
Write a query identifying the type of each record in the TRIANGLES table using 
its three side lengths. Output one of the following statements for each record in the table:

Equilateral: It's a triangle with  sides of equald length.
Isosceles: It's a triangle with  sides of equal length.
Scalene: It's a triangle with  sides of differing lengths.
Not A Triangle: The given values of A, B, and C don't form a triangle.

*/

SELECT CASE
        WHEN A + B <= C OR A + C <= B OR B + C <= A THEN 'Not A Triangle'
        WHEN A = B AND B = C THEN 'Equilateral'
        WHEN A = B OR B = C OR A = C THEN 'Isosceles'
        ELSE 'Scalene'
    END
FROM TRIANGLES;


/*
-----------
The PADS
------------
Generate the following two result sets:

Query an alphabetically ordered list of all names in OCCUPATIONS, 
immediately followed by the first letter of each profession as a parenthetical 
(i.e.: enclosed in parentheses). For example: AnActorName(A), ADoctorName(D), 
AProfessorName(P), and ASingerName(S).

Query the number of ocurrences of each occupation in OCCUPATIONS. 
Sort the occurrences in ascending order, and output them in the following format:
There are a total of [occupation_count] [occupation]s.
where [occupation_count] is the number of occurrences of an occupation in 
OCCUPATIONS and [occupation] is the lowercase occupation name. If more than one 
Occupation has the same [occupation_count], they should be ordered alphabetically.

Note: There will be at least two entries in the table for each type of occupation.

*/

SELECT CONCAT(Name,'(', LEFT(Occupation, 1), ')')
FROM OCCUPATIONS
ORDER BY name;

WITH CTE(occupation, occupation_count) AS (

SELECT LOWER(Occupation), COUNT(*)
FROM OCCUPATIONS
GROUP BY Occupation
)

SELECT CONCAT('There are a total of ', occupation_count, ' ', occupation, 's.')
FROM CTE
ORDER BY occupation_count, occupation;


-----------------
/*Occupations
-----------------
Pivot the Occupation column in OCCUPATIONS so that each Name is sorted 
alphabetically and displayed underneath its corresponding Occupation. 
The output column headers should be Doctor, Professor, Singer, and Actor, respectively.

Note: Print NULL when there are no more names corresponding to an occupation.
*/



select
    Doctor,
    Professor,
    Singer,
    Actor
from (
    select
        NameOrder,
        max(case Occupation when 'Doctor' then Name end) as Doctor,
        max(case Occupation when 'Professor' then Name end) as Professor,
        max(case Occupation when 'Singer' then Name end) as Singer,
        max(case Occupation when 'Actor' then Name end) as Actor
    from (
            select
                Occupation,
                Name,
                row_number() over(partition by Occupation order by Name ASC) as NameOrder
            from Occupations
         ) as NameLists
    group by NameOrder
    ) as Names


/*--------------------
--Binary Tree Nodes
--------------------
You are given a table, BST, containing two columns: N and P, where N represents the 
value of a node in Binary Tree, and P is the parent of N.

Write a query to find the node type of Binary Tree ordered by the 
value of the node. Output one of the following for each node:

Root: If node is root node.
Leaf: If node is leaf node.
Inner: If node is neither root nor leaf node.

*/

SELECT N,
    CASE
        WHEN P IS NULL THEN 'Root'
        WHEN N IN (SELECT P FROM BST) THEN 'Inner'
        ELSE 'Leaf'
    END
FROM BST
ORDER BY N;


/*------------
New Companies
---------------
Amber's conglomerate corporation just acquired some new companies. Each of the companies follows this hierarchy:

Given the table schemas below, write a query to print the company_code, founder name, total number of lead managers, total number of senior managers, total number of managers, and total number of employees. Order your output by ascending company_code.

Note:

The tables may contain duplicate records.
The company_code is string, so the sorting should not be numeric. For example, if the company_codes are C_1, C_2, and C_10, then the ascending company_codes will be C_1, C_10, and C_2.
Input Format

The following tables contain company data:

Company: The company_code is the code of the company and founder is the founder of the company.

Lead_Manager: The lead_manager_code is the code of the lead manager, and the company_code is the code of the working company.

Senior_Manager: The senior_manager_code is the code of the senior manager, the lead_manager_code is the code of its lead manager, and the company_code is the code of the working company.

Manager: The manager_code is the code of the manager, the senior_manager_code is the code of its senior manager, the lead_manager_code is the code of its lead manager, and the company_code is the code of the working company.

Employee: The employee_code is the code of the employee, the manager_code is the code of its manager, the senior_manager_code is the code of its senior manager, the lead_manager_code is the code of its lead manager, and the company_code is the code of the working company.

Sample Input

Company Table:Lead_Manager Table:Senior_Manager Table:Manager Table:Employee Table:


*/

SELECT 
	c.company_code, 
	c.founder, 
	COUNT(DISTINCT e.lead_manager_code), 
	COUNT(DISTINCT e.senior_manager_code), 
	COUNT(DISTINCT e.manager_code), 
	COUNT(DISTINCT e.employee_code) 
FROM company c
JOIN employee e 
ON c.company_code = e.company_code 
GROUP BY c.company_code, c.founder 
ORDER BY c.company_code;


/*
Population Census
Given the CITY and COUNTRY tables, query the sum of the populations of all 
cities where the CONTINENT is 'Asia'.

Note: CITY.CountryCode and COUNTRY.Code are matching key columns.
*/

SELECT SUM(CITY.POPULATION)
FROM CITY
INNER JOIN COUNTRY 
ON CITY.COUNTRYCODE = COUNTRY.CODE
WHERE COUNTRY.CONTINENT = 'Asia';


/*
African Cities

Given the CITY and COUNTRY tables, query the names of all cities where the CONTINENT is 'Africa'.

Note: CITY.CountryCode and COUNTRY.Code are matching key columns.
*/

SELECT CITY.NAME
FROM CITY
INNER JOIN COUNTRY 
ON CITY.COUNTRYCODE = COUNTRY.CODE
WHERE COUNTRY.CONTINENT = 'Africa';


/*----------------------------------
Average Population of Each Continent
------------------------------------
Given the CITY and COUNTRY tables, query the names of all the continents 
(COUNTRY.Continent) and their respective average city populations (CITY.Population) 
rounded down to the nearest integer.

Note: CITY.CountryCode and COUNTRY.Code are matching key columns.
*/

SELECT COUNTRY.CONTINENT, ROUND(AVG(CITY.POPULATION),0)
FROM CITY
INNER JOIN COUNTRY 
ON CITY.COUNTRYCODE = COUNTRY.CODE
GROUP BY COUNTRY.CONTINENT;


/*--------
The Report
----------
Ketty gives Eve a task to generate a report containing three columns: 
Name, Grade and Mark. Ketty doesn't want the NAMES of those students 
who received a grade lower than 8. The report must be in descending order by grade 
-- i.e. higher grades are entered first. If there is more than one student with 
the same grade (8-10) assigned to them, order those particular students by their 
name alphabetically. Finally, if the grade is lower than 8, use "NULL" as their 
name and list them by their grades in descending order. If there is more than one 
student with the same grade (1-7) assigned to them, order those particular students 
by their marks in ascending order.

Write a query to help Eve.
*/

SELECT 
    CASE WHEN g.grade < 8 THEN NULL 
    WHEN g.grade >= 8 THEN s.name END,
    g.grade, s.marks FROM students s, grades g
WHERE s.marks BETWEEN g.min_mark AND g.max_mark
ORDER BY g.grade DESC, s.name ASC;



/*-------------
Top Competitors
---------------
Julia just finished conducting a coding contest, and she needs your help assembling 
the leaderboard! Write a query to print the respective hacker_id and name of hackers 
who achieved full scores for more than one challenge. Order your output in descending 
order by the total number of challenges in which the hacker earned a full score. 
If more than one hacker received full scores in same number of challenges, 
then sort them by ascending hacker_id.
*/



SELECT h.hacker_id, h.name
FROM Submissions s
JOIN Hackers h
ON h.hacker_id = s.hacker_id
JOIN Challenges c
ON c.challenge_id = s.challenge_id
JOIN Difficulty d
ON d.difficulty_level = c.difficulty_level
WHERE d.score = s.score
GROUP BY h.hacker_id, h.name
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC, h.hacker_id;



/*--------------------
Ollivander's Inventory
----------------------
Harry Potter and his friends are at Ollivander's with Ron, finally replacing Charlie's 
old broken wand.

Hermione decides the best way to choose is by determining the minimum number of gold 
galleons needed to buy each non-evil wand of high power and age. Write a query 
to print the id, age, coins_needed, and power of the wands that Ron's interested in, 
sorted in order of descending power. If more than one wand has same power, 
sort the result in order of descending age.
*/

SELECT wd.id, wp.age, wd.coins_needed, wd.power 
FROM Wands  wd 
INNER JOIN Wands_Property wp
ON wd.code = wp.code
WHERE wd.coins_needed = (SELECT min(coins_needed)
                       FROM Wands wd2 INNER JOIN Wands_Property wp2 
                       on wd2.code = wp2.code 
                       WHERE wp2.is_evil = 0 AND wp.age = wp2.age AND wd.power = wd2.power)
ORDER BY wd.power DESC, wp.age DESC;