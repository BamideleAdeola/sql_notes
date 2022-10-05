/*
	EXPLORATORY DATA ANALYSIS IN SQL - MY NOTE
--------------------------------------------
*/

/* CHALLENGE
Subtract the count of the non-NULL ticker values 
from the total number of rows; alias the difference as missing.
*/

-- Select the count of ticker, 
-- subtract from the total number of rows, 
-- and alias as missing
SELECT count(*) - COUNT(ticker) AS missing
  FROM fortune500;
  
/* CHALLENGE

Look at the contents of the company and fortune500 tables. Find a column that they have in common where the values for each company are the same in both tables.
Join the company and fortune500 tables with an INNER JOIN.
Select only company.name for companies that appear in both tables.

*/

SELECT company.name
-- Table(s) to select from
  FROM company
       INNER JOIN fortune500
       ON company.ticker=fortune500.ticker;


-- Count the number of tags with each type
SELECT type, COUNT(*) AS count
  FROM tag_type
 -- To get the count for each type, what do you need to do?
 GROUP BY type
 -- Order the results with the most common
 -- tag types listed first
 ORDER BY type;
 
 
 /* CHALLENGE
 Join the tag_company, company, and tag_type 
 tables, keeping only mutually occurring records.
 
 Select company.name, tag_type.tag, and 
 tag_type.type for tags with the most common type 
 from the previous step.
 */


-- Select the 3 columns desired
SELECT company.name, tag_type.tag, tag_type.type
  FROM company
  	   -- Join to the tag_company table
       INNER JOIN tag_company 
       ON company.id = tag_company.company_id
       -- Join to the tag_type table
       INNER JOIN tag_type
       ON tag_company.tag = tag_type.tag
  -- Filter to most common type
  WHERE type='cloud';
  
  
  /* CHALLENGE - COALESCE FUNCTION
Use coalesce() to select the first non-NULL value from 
industry, sector, or 'Unknown' as a fallback value.

Alias the result of the call to coalesce() as industry2.

Count the number of rows with each industry2 value.

Find the most common value of industry2.
  */
  
-- Use coalesce
SELECT COALESCE(industry, sector, 'Unknown') AS industry2,
       -- Don't forget to count!
       COUNT(*) 
  FROM fortune500 
-- Group by what? (What are you counting by?)
 GROUP BY industry2
-- Order results to see most common first
 ORDER BY COUNT(*) DESC
-- Limit results to get just the one value you want
 LIMIT 1;


/*
Join company to itself to add information about a 
company's parent to the original company's information.

Use coalesce to get the parent company ticker if 
available and the original company ticker otherwise.

INNER JOIN to fortune500 using the ticker.

Select original company name, fortune500 title and rank.
*/

SELECT company_original.name, title, rank
  -- Start with original company information
  FROM company AS company_original
       -- Join to another copy of company with parent
       -- company information
	   LEFT JOIN company AS company_parent
       ON company_original.parent_id= company_parent.id 
       -- Join to fortune500, only keep rows that match
       INNER JOIN fortune500 
       -- Use parent ticker if there is one, 
       -- otherwise original ticker
       ON coalesce(company_parent.ticker, 
                   company_original.ticker) = 
             fortune500.ticker
 -- For clarity, order by rank
 ORDER BY rank;
 
-- CASTING VALUES - This is an approach to convert data to another data type in a query
-- SELECT CAST(VALUE AS new_type)
SELECT CAST(3.7 AS integer)
-- Alternate quotations can also be used for CASTING
SELECT 3.7::integer;

/*
Select profits_change and profits_change cast as 
integer from fortune500.

Look at how the values were converted.
*/

-- Select the original value
SELECT profits_change, 
	   -- Cast profits_change
       CAST(profits_change AS integer) AS profits_change_int
  FROM fortune500;


/*
Compare the results of casting of dividing the integer 
value 10 by 3 to the result of dividing the numeric 
value 10 by 3.
*/

-- Divide 10 by 3
SELECT 10/3, 
       -- Cast 10 as numeric and divide by 3
       10::numeric/3;



/*
Now cast numbers that appear as text as numeric.
Note: 1e3 is scientific notation.
*/

SELECT '3.2'::numeric,
       '-123'::numeric,
       '1e3'::numeric,
       '1e-3'::numeric,
       '02314'::numeric,
       '0002'::numeric;
/* NOTE
numbers cast as integer are rounded 
to the nearest whole number and division produces 
different results for integer values than for numeric values.
*/

/* CHALLENGE
Use GROUP BY and count() to examine the values of revenues_change.
Order the results by revenues_change to see the distribution.
*/

-- Select the count of each value of revenues_change
SELECT revenues_change, COUNT(revenues_change)
  FROM fortune500
 GROUP BY revenues_change
 -- order by the values of revenues_change
 ORDER BY revenues_change;

-- Repeat step 1, but this time, cast revenues_change 
-- as an integer to reduce the number of different values.
-- Select the count of each revenues_change integer value
SELECT revenues_change::integer, COUNT(revenues_change)
  FROM fortune500
 GROUP BY revenues_change::integer
 -- order by the values of revenues_change
 ORDER BY revenues_change;


/*
How many of the Fortune 500 companies had
revenues increase in 2017 compared to 2016? To find 
out, count the rows of fortune500 where revenues_change indicates an increase.
*/

-- Count rows 
SELECT COUNT(*)
  FROM fortune500
 -- Where...
 WHERE revenues_change > 0.0;

/* 
NUMERIC DATA TYPES AND SUMMARY FUNCTIONS
These are MIN, MAX, AVG, VARIANCE
*/

SELECT VAR_POP(question_pct) FROM stackoverflow; -- Population Variance
SELECT VAR_SAMP(question_pct) FROM stackoverflow; --Sample Variance
SELECT STDDEV(question_pct) FROM stackoverflow;

-- Use ROUND to convert the values of a numeric value to a specific unit or decimal places

/* CHALLENGE - Compute the average revenue per employee for Fortune 500 companies by sector.
Compute revenue per employee by dividing revenues 
by employees; use casting to produce a numeric result.

Take the average of revenue per employee with avg(); 
alias this as avg_rev_employee.

Group by sector.

Order by the average revenue per employee.
*/

-- Select average revenue per employee by sector
SELECT sector, 
       AVG(revenues/employees::numeric) AS avg_rev_employee
  FROM fortune500
 GROUP BY sector
 -- Use the column alias to order the results
 ORDER BY avg_rev_employee;


/* CHALLENGE
Exclude rows where question_count is 0 to avoid a 
divide by zero error.

Limit the result to 10 rows.
*/

-- Divide unanswered_count by question_count
SELECT unanswered_count/question_count::NUMERIC AS computed_pct, 
       -- What are you comparing the above quantity to?
       unanswered_pct
  FROM stackoverflow
 -- Select rows where question_count is not 0
 WHERE question_count > 0
 LIMIT 10;

/* CHALLENGE
Compute the min(), avg(), max(), and stddev() of profits.
*/

-- Select min, avg, max, and stddev of fortune500 profits
SELECT MIN(profits),
       AVG(profits),
       MAX(profits),
       STDDEV(profits)
  FROM fortune500;

/* CHALLENGE
Now repeat step 1, but summarize profits by sector.
Order the results by the average profits for each sector.
*/

-- Select sector and summary measures of fortune500 profits
SELECT sector,
       MIN(profits),
       AVG(profits),
       MAX(profits),
       STDDEV(profits)
  FROM fortune500
 -- What to group by?
 GROUP BY sector
 -- Order by the average profits
 ORDER BY AVG(profits);


/*
Start by writing a subquery to compute the max() of 
question_count per tag; alias the subquery result as maxval.

Then compute the standard deviation of maxval with stddev().

Compute the min(), max(), and avg() of maxval too.
*/

-- Compute standard deviation of maximum values
SELECT STDDEV(maxval),
	   -- min
       MIN(maxval),
       -- max
       MAX(maxval),
       -- avg
       AVG(maxval)
  -- Subquery to compute max of question_count by tag
  FROM (SELECT MAX(question_count) AS maxval
          FROM stackoverflow
         -- Compute max by...
         GROUP BY tag) AS max_results; -- alias for subquery



-- Trunc, Generate_series
generate_series(start, end, step)

-- Creating bins with generate_series function
WITH bins AS (
	SELECT generate_series(30, 60, 5) AS lower,
			generate_series(35,65, 5) AS upper),
	
	-- create another CTE
	ebs AS (
	  SELECT unanswered_count
		FROM stackoverflow
		WHERE tag = 'amazon-ebs')
-- write the main query
SELECT lower, upper, COUNT(unanswered_count)
	--left join jeeps all bins
	FROM bins
	LEFT JOIN ebs
		ON unanswered_count >= lower
		AND unanswered_count < upper
GROUP BY lower, upper
ORDER BY lower;

/*
Use trunc() to truncate employees to the 100,000s (5 zeros).
Count the number of observations with each truncated value.
*/


-- Truncate employees
SELECT TRUNC(employees, -5) AS employee_bin,
       -- Count number of companies with each truncated value
       COUNT(*)
  FROM fortune500
 -- Use alias to group
 GROUP BY employee_bin
 -- Use alias to order
 ORDER BY employee_bin;
 
/*
Repeat step 1 for companies with < 100,000 employees (most common).
This time, truncate employees to the 10,000s place.
*/

-- Truncate employees
SELECT TRUNC(employees, -4) AS employee_bin,
       -- Count number of companies with each truncated value
       COUNT(*)
  FROM fortune500
 -- Limit to which companies?
 WHERE employees < 100000
 -- Use alias to group
 GROUP BY employee_bin
 -- Use alias to order
 ORDER BY employee_bin;
 
 
/* CHALLENGE
Start by selecting the minimum and maximum of the 
question_count column for the tag 'dropbox' so you 
know the range of values to cover with the bins.
*/

-- Select the min and max of question_count
SELECT MAX(question_count), 
       MIN(question_count)
  -- From what table?
  FROM stackoverflow
 -- For tag dropbox
 WHERE tag = 'dropbox';
 


/* CHALLENGE
Next, use generate_series() to create bins of size 50 from 2200 to 3100.

To do this, you need an upper and lower bound to define a bin.

This will require you to modify the stopping value of the lower bound and the starting value of the upper bound by the bin width.
*/

-- Create lower and upper bounds of bins
SELECT generate_series(2200, 3050, 50) AS lower,
       generate_series(2250, 3100, 50) AS upper;


/* CHALLENGE
Select lower and upper from bins, along with the count of values within each bin bounds.

To do this, you'll need to join 'dropbox', which contains the question_count for tag "dropbox", to the bins created by generate_series().

The join should occur where the count is greater than or equal to the lower bound, and strictly less than the upper bound.
*/

-- Bins created in Step 2
WITH bins AS (
      SELECT generate_series(2200, 3050, 50) AS lower,
             generate_series(2250, 3100, 50) AS upper),
     -- Subset stackoverflow to just tag dropbox (Step 1)
     dropbox AS (
      SELECT question_count 
        FROM stackoverflow
       WHERE tag='dropbox') 
-- Select columns for result
-- What column are you counting to summarize?
SELECT lower, upper, count(question_count) 
  FROM bins  -- Created above
       -- Join to dropbox (created above), 
       -- keeping all rows from the bins table in the join
       LEFT JOIN dropbox
       -- Compare question_count to lower and upper
         ON question_count >= lower 
        AND question_count < upper
 -- Group by lower and upper to count values in each bin
 GROUP BY lower, upper
 -- Order by lower to put bins in order
 ORDER BY lower;


-- MORE SUMMARY STATISTICS
a. Corr - correlation
b. Median 
c. percentile
SELECT percentile_disc(percentile) WITHIN GROUP (ORDER BY column_name)
FROM table; -- discrete

SELECT percentile_cont(percentile) WITHIN GROUP (ORDER BY column_name)
FROM table; --continuos


/*
What's the relationship between a company's revenue and 
its other financial attributes? Compute the correlation 
between revenues and other financial variables with the corr() function.
*/

/* Steps
Compute the correlation between revenues and profits.
Compute the correlation between revenues and assets.
Compute the correlation between revenues and equity.
*/

-- Correlation between revenues and profit
SELECT CORR(revenues, profitS) AS rev_profits,
	   -- Correlation between revenues and assets
       CORR(revenues, assets) AS rev_assets,
       -- Correlation between revenues and equity
       CORR(revenues, equity) AS rev_equity 
  FROM fortune500;
  

/*
Mean and Median
Compute the mean (avg()) and median assets of Fortune 500 companies by sector.
Use the percentile_disc() function to compute the median:
percentile_disc(0.5) 
WITHIN GROUP (ORDER BY column_name)
*/

/* STEPS
Select the mean and median of assets.
Group by sector.
Order the results by the mean.
*/

-- What groups are you computing statistics by?
SELECT sector,
       -- Select the mean of assets with the avg function
       AVG(assets) AS mean,
       -- Select the median
       PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY assets) AS median
  FROM fortune500
 -- Computing statistics for each what?
 GROUP BY sector
 -- Order results by a value of interest
 ORDER BY mean;
 
/*
CREATING TEMPORARY TABLE
*/

-- Create the temporary table as 
SELECT TEMP TABLE new_tablename AS
-- What you intend to store within this table
SELECT column1, column2,...
FROM table;

-- Or
SELECT column1, column2,...
-- State a clause to direct the outcomes into a temp table
  INTO TEMP TABLE new_tablename
  -- insert existing table name of the selected columns
  FROM table;
  
-- CREATE A TEMP TABLE FOR THE TOP 10 FORTUNE500 COMPANIES
CREATE TEMP TABLE top_companies AS
SELECT rank, title
FROM fortune500
WHERE rank <= 10;

/*
Find the Fortune 500 companies that have profits in 
the top 20% for their sector (compared to other Fortune 500 companies).
*/

/* Challenge 1 -  step 1
Create a temporary table called profit80 
containing the sector and 80th percentile of profits for each sector.

Alias the percentile column as pct80.
*/

-- To clear table if it already exists;
-- fill in name of temp table
DROP TABLE IF EXISTS profit80;

-- Create the temporary table
CREATE TEMP TABLE profit80 AS 
  -- Select the two columns you need; alias as needed
  SELECT sector, 
         PERCENTILE_DISC(0.8) WITHIN GROUP (ORDER BY profits) AS pct80
    -- What table are you getting the data from?
    FROM fortune500
   -- What do you need to group by?
   GROUP BY sector;
   
-- See what you created: select all columns and rows 
-- from the table you created
SELECT * 
  FROM profit80;


/* Challenge 1 - step 2
Using the profit80 table you created in step 1, 
select companies that have profits greater than pct80.

Select the title, sector, profits from 
fortune500, as well as the ratio of the company's 
profits to the 80th percentile profit.
*/

-- Code from previous step
DROP TABLE IF EXISTS profit80;

CREATE TEMP TABLE profit80 AS
  SELECT sector, 
         percentile_disc(0.8) WITHIN GROUP (ORDER BY profits) AS pct80
    FROM fortune500 
   GROUP BY sector;

-- Select columns, aliasing as needed
SELECT title, fortune500.sector, 
       profits, profits/pct80 AS ratio
-- What tables do you need to join?  
  FROM fortune500 
       LEFT JOIN profit80
-- How are the tables joined?
       ON fortune500.sector=profit80.sector
-- What rows do you want to select?
 WHERE profits > pct80;


/*
Find out how many questions had each tag on the first 
date for which data for the tag is available, as well as how 
many questions had the tag on the last day. 
Also, compute the difference between these two values.
*/

/* Step 1
First, create a temporary table called startdates 
with each tag and the min() date for the tag in stackoverflow.
*/

-- To clear table if it already exists
DROP TABLE IF EXISTS startdates;

-- Create temp table syntax
CREATE TEMP TABLE startdates AS
-- Compute the minimum date for each what?
SELECT tag,
       MIN(date) AS mindate
  FROM stackoverflow
 -- What do you need to compute the min date for each tag?
 GROUP BY tag;
 
 -- Look at the table you created
 SELECT * 
   FROM startdates;
   


/* Step 2
Join startdates to stackoverflow twice using different table aliases.
For each tag, select mindate, question_count on the mindate, and question_count on 2018-09-25 (the max date).
Compute the change in question_count over time.
*/

-- To clear table if it already exists
DROP TABLE IF EXISTS startdates;

CREATE TEMP TABLE startdates AS
SELECT tag, min(date) AS mindate
  FROM stackoverflow
 GROUP BY tag;
 
-- Select tag (Remember the table name!) and mindate
SELECT startdates.tag, 
       mindate, 
       -- Select question count on the min and max days
	   so_min.question_count AS min_date_question_count,
       so_max.question_count AS max_date_question_count,
       -- Compute the change in question_count (max- min)
       so_max.question_count - so_min.question_count AS change
  FROM startdates
       -- Join startdates to stackoverflow with alias so_min
       INNER JOIN stackoverflow AS so_min
          -- What needs to match between tables?
          ON startdates.tag = so_min.tag
         AND startdates.mindate = so_min.date
       -- Join to stackoverflow again with alias so_max
       INNER JOIN stackoverflow AS so_max
       	  -- Again, what needs to match between tables?
          ON startdates.tag = so_max.tag
         AND so_max.date = '2018-09-25';




/* MAJOR CHALLENGE
Compute the correlations between each pair of profits, 
profits_change, and revenues_change from the Fortune 500 data.
*/


/*
Create a temp table correlations.

Compute the correlation between profits and each 
of the three variables (i.e. correlate profits with 
profits, profits with profits_change, etc).

Alias columns by the name of the variable for which 
the correlation with profits is being computed.
*/

DROP TABLE IF EXISTS correlations;

-- Create temp table 
CREATE TEMP TABLE correlations AS
-- Select each correlation
SELECT 'profits'::varchar AS measure,
       -- Compute correlations
       CORR(profits, profits) AS profits,
       CORR(profits, profits_change) AS profits_change,
       CORR(profits, revenues_change) AS revenues_change
  FROM fortune500;

/* step 2
Insert rows into the correlations table for profits_change and revenues_change.
*/

DROP TABLE IF EXISTS correlations;

CREATE TEMP TABLE correlations AS
SELECT 'profits'::varchar AS measure,
       corr(profits, profits) AS profits,
       corr(profits, profits_change) AS profits_change,
       corr(profits, revenues_change) AS revenues_change
  FROM fortune500;

-- Add a row for profits_change
-- Insert into what table?
INSERT INTO correlations
-- Follow the pattern of the select statement above
-- Using profits_change instead of profits
SELECT 'profits_change'::varchar AS measure,
       corr(profits_change, profits) AS profits,
       corr(profits_change, profits_change) AS profits_change,
       corr(profits_change, revenues_change) AS revenues_change
  FROM fortune500;

-- Repeat the above, but for revenues_change
INSERT INTO correlations
SELECT 'revenues_change'::varchar AS measure,
       corr(revenues_change, profits) AS profits,
       corr(revenues_change, profits_change) AS profits_change,
       corr(revenues_change, revenues_change) AS revenues_change
  FROM fortune500;


/*
Select all rows and columns from the correlations table to view the correlation matrix.

First, you will need to round each correlation to 2 decimal places.

The output of corr() is of type double precision, so you will need to also cast columns to numeric.
*/

DROP TABLE IF EXISTS correlations;

CREATE TEMP TABLE correlations AS
SELECT 'profits'::varchar AS measure,
       corr(profits, profits) AS profits,
       corr(profits, profits_change) AS profits_change,
       corr(profits, revenues_change) AS revenues_change
  FROM fortune500;

INSERT INTO correlations
SELECT 'profits_change'::varchar AS measure,
       corr(profits_change, profits) AS profits,
       corr(profits_change, profits_change) AS profits_change,
       corr(profits_change, revenues_change) AS revenues_change
  FROM fortune500;

INSERT INTO correlations
SELECT 'revenues_change'::varchar AS measure,
       corr(revenues_change, profits) AS profits,
       corr(revenues_change, profits_change) AS profits_change,
       corr(revenues_change, revenues_change) AS revenues_change
  FROM fortune500;

-- Select each column, rounding the correlations
SELECT measure, 
       ROUND(profits::NUMERIC, 2) AS profits,
       ROUND(profits_change::NUMERIC, 2) AS profits_change,
       ROUND(revenues_change::NUMERIC,2) AS revenues_change
  FROM correlations;
  
/*
How many rows does each priority level have?
*/

-- Select the count of each level of priority
SELECT 
  priority, 
  COUNT(*)
 FROM evanston311
 

-- How many distinct values of zip appear in at least 100 rows?
-- Find values of zip that appear in at least 100 rows
-- Also get the count of each value
SELECT DISTINCT zip, COUNT(*)
  FROM evanston311
 GROUP BY zip
HAVING COUNT(*) >= 100; 

-- How many distinct values of source appear in at least 100 rows?
-- Find values of source that appear in at least 100 rows
-- Also get the count of each value
SELECT DISTINCT source, COUNT(*)
  FROM evanston311
 GROUP BY source
HAVING COUNT(*) >= 100;


Select the five most common values of street and the count of each.

-- Find the 5 most common values of street and the count of each
SELECT DISTINCT street, COUNT(*)
  FROM evanston311
 GROUP BY street
 ORDER BY COUNT(*) DESC
 LIMIT 5;
 
 
/*
LIKE and ILIKE function
*/
/* ILIKE is majorly used for case insensitive search or filter

Trim or btrim removes spaces from both right and left side of the character
rtrim -  from the right
ltrim - from the left

One can also remove some charecters totally from a word by specifying them.
*/

/* CHALLENGE
Trimming
Some of the street values in evanston311 include house 
numbers with # or / in them. In addition, some street values end in a ..

Remove the house numbers, extra punctuation, and any 
spaces from the beginning and end of the street values 
as a first attempt at cleaning up the values.
*/

SELECT distinct street,
       -- Trim off unwanted characters from street
       trim(street, '0123456789 #/.') AS cleaned_street
  FROM evanston311
 ORDER BY street;

/* 
Use ILIKE to count rows in evanston311 where the 
description contains 'trash' or 'garbage' regardless of case.
*/

-- Count rows
SELECT COUNT(*)
  FROM evanston311
 -- Where description includes trash or garbage
 WHERE description ILIKE '%trash%'
    OR description ILIKE '%garbage%';


/*
category values are in title case. Use LIKE to find 
category values with 'Trash' or 'Garbage' in them.
*/

-- Select categories containing Trash or Garbage
SELECT category
  FROM evanston311
 -- Use LIKE
 WHERE category LIKE '%Trash%'
    OR category LIKE '%Garbage%';


/*
Count rows where the description includes 'trash' or 
'garbage' but the category does not.
*/

-- Count rows
SELECT COUNT(*)
  FROM evanston311 
 -- description contains trash or garbage (any case)
 WHERE (description ILIKE '%trash%'
    OR description ILIKE '%garbage%') 
 -- category does not contain Trash or Garbage
   AND category NOT LIKE '%Trash%'
   AND category NOT LIKE '%Garbage%';


/*
Find the most common categories for rows with a 
description about trash that don't have a trash-related category.
*/

-- Count rows with each category
SELECT category, COUNT(*)
  FROM evanston311 
 WHERE (description ILIKE '%trash%'
    OR description ILIKE '%garbage%') 
   AND category NOT LIKE '%Trash%'
   AND category NOT LIKE '%Garbage%'
 -- What are you counting?
 GROUP BY category
 --- order by most frequent values
 ORDER BY COUNT(*) DESC
 LIMIT 10;
 
 
/*
Concatenate house_num, a space ' ', and street into 
a single value using the concat().

Use a trim function to remove any spaces from the start 
of the concatenated value.
*/

-- Concatenate house_num, a space, and street
-- and trim spaces from the start of the result
SELECT TRIM(CONCAT(house_num, ' ', street)) AS address
  FROM evanston311;


/*
Use split_part() to select the first word in street; alias the result as street_name.
Also select the count of each value of street_name.
*/

-- Select the first word of the street value
SELECT SPLIT_PART(street, ' ', 1) AS street_name, 
       count(*)
  FROM evanston311
 GROUP BY street_name
 ORDER BY count DESC
 LIMIT 20;


/*
Select the first 50 characters of description with 
'...' concatenated on the end where the length() of 
the description is greater than 50 characters. 
Otherwise just select the description as is.

Select only descriptions that begin with the word 'I' and 
not the letter 'I'.

For example, you would want to select "I like using SQL!", 
but would not want to select "In this course we use SQL!".
*/

-- Select the first 50 chars when length is greater than 50
SELECT CASE WHEN length(description) > 50
            THEN left(description, 50) || '...'
       -- otherwise just select description
       ELSE description
       END
  FROM evanston311
 -- limit to descriptions that start with the word I
 WHERE description LIKE 'I %'
 ORDER BY description;


-- CASE WHEN 
SELECT CASE WHEN category LIKE '%: %' THEN SPLIT_PART(category, ': ', 1)
			WHEN category LIKE '% - %' THEN SPLIT_PART(category, ' - ', 1)
			ELSE SPLIT_PART(category, ' | ', 1)
		END AS major_category,
		SUM(businesses)
	FROM naics
	
GROUP BY major_category;

/*
Create recode with a standardized column; use 
split_part() and then rtrim() to remove any 
remaining whitespace on the result of split_part().
*/

-- Fill in the command below with the name of the temp table
DROP TABLE IF EXISTS recode;

-- Create and name the temporary table
CREATE TEMP TABLE recode AS
-- Write the select query to generate the table 
-- with distinct values of category and standardized values
  SELECT DISTINCT category, 
         rtrim(split_part(category, '-', 1)) AS standardized
    -- What table are you selecting the above values from?
    FROM evanston311;
    
-- Look at a few values before the next step
SELECT DISTINCT standardized 
  FROM recode
 WHERE standardized LIKE 'Trash%Cart'
    OR standardized LIKE 'Snow%Removal%';


/*

UPDATE standardized values LIKE 'Trash%Cart' to 'Trash Cart'.

UPDATE standardized values of 'Snow 
Removal/Concerns' and 'Snow/Ice/Hazard Removal' to 'Snow Removal'.
*/

-- Code from previous step
DROP TABLE IF EXISTS recode;

CREATE TEMP TABLE recode AS
  SELECT DISTINCT category, 
         rtrim(split_part(category, '-', 1)) AS standardized
    FROM evanston311;

-- Update to group trash cart values
UPDATE recode 
   SET standardized='Trash Cart' 
 WHERE standardized LIKE 'Trash%Cart';

-- Update to group snow removal values
UPDATE recode 
   SET standardized ='Snow Removal' 
 WHERE standardized LIKE 'Snow%Removal%';
    
-- Examine effect of updates
SELECT DISTINCT standardized 
  FROM recode
 WHERE standardized LIKE 'Trash%Cart'
    OR standardized LIKE 'Snow%Removal%';


/*

UPDATE standardized values LIKE 'Trash%Cart' to 'Trash Cart'.

UPDATE standardized values of 'Snow 
Removal/Concerns' and 'Snow/Ice/Hazard Removal' to 'Snow Removal'.
*/

-- Code from previous step
DROP TABLE IF EXISTS recode;

CREATE TEMP TABLE recode AS
  SELECT DISTINCT category, 
         rtrim(split_part(category, '-', 1)) AS standardized
    FROM evanston311;
  
UPDATE recode SET standardized='Trash Cart' 
 WHERE standardized LIKE 'Trash%Cart';

UPDATE recode SET standardized='Snow Removal' 
 WHERE standardized LIKE 'Snow%Removal%';

-- Update to group unused/inactive values
UPDATE recode 
   SET standardized='UNUSED' 
 WHERE standardized IN ('THIS REQUEST IS INACTIVE...Trash Cart', 
               '(DO NOT USE) Water Bill',
               'DO NOT USE Trash', 
               'NO LONGER IN USE');

-- Examine effect of updates
SELECT DISTINCT standardized 
  FROM recode
 ORDER BY standardized;
 
/*
Now, join the evanston311 and recode tables to count the number of 
requests with each of the standardized values

List the most common standardized values first.
*/

-- Code from previous step
DROP TABLE IF EXISTS recode;
CREATE TEMP TABLE recode AS
  SELECT DISTINCT category, 
         rtrim(split_part(category, '-', 1)) AS standardized
  FROM evanston311;
UPDATE recode SET standardized='Trash Cart' 
 WHERE standardized LIKE 'Trash%Cart';
UPDATE recode SET standardized='Snow Removal' 
 WHERE standardized LIKE 'Snow%Removal%';
UPDATE recode SET standardized='UNUSED' 
 WHERE standardized IN ('THIS REQUEST IS INACTIVE...Trash Cart', 
               '(DO NOT USE) Water Bill',
               'DO NOT USE Trash', 'NO LONGER IN USE');

-- Select the recoded categories and the count of each
SELECT standardized, count(*) 
-- From the original table and table with recoded values
  FROM evanston311 
       LEFT JOIN recode 
       -- What column do they have in common?
       ON evanston311.category=recode.category 
 -- What do you need to group by to count?
 GROUP BY standardized
 -- Display the most common val values first
 ORDER BY count DESC;
 
 
 /*
 
 Join the indicators table to evanston311, selecting the proportion of reports including an email or phone grouped by priority.
Include adjustments to account for issues arising from integer division.
 */
 
 -- To clear table if it already exists
DROP TABLE IF EXISTS indicators;

-- Create the temp table
CREATE TEMP TABLE indicators AS
  SELECT id, 
         CAST (description LIKE '%@%' AS integer) AS email,
         CAST (description LIKE '%___-___-____%' AS integer) AS phone 
    FROM evanston311;

-- Select the column you'll group by
SELECT priority, 
       -- Compute the proportion of rows with each indicator
       sum(email)/count(*)::numeric AS email_prop, 
       sum(phone)/count(*)::numeric AS phone_prop 
  -- Tables to select from
  FROM evanston311
       LEFT JOIN indicators
       -- Joining condition
       ON evanston311.id=indicators.id
 -- What are you grouping by?
 GROUP BY priority; 
 
 /*
 Count the number of Evanston 311 requests created 
 on January 31, 2017 by casting date_created to a date.
 */
 
 -- Count requests created on January 31, 2017
SELECT count(*) 
  FROM evanston311
 WHERE date_created::date = '2017-01-31';
 
 
  /*
 Count the number of Evanston 311 requests created 
 on January 31, 2017 by casting date_created to a date.
 */
 
 -- Count requests created on February 29, 2016
SELECT count(*)
  FROM evanston311 
 WHERE date_created >= '2016-02-29' 
   AND date_created < '2016-03-01';



  /*
Count the number of requests created on March 13, 2017.
 */
 
 -- Count requests created on March 13, 2017
SELECT count(*)
  FROM evanston311
 WHERE date_created >= '2017-03-13'
   AND date_created < '2017-03-13'::date + 1;
   

  /*
Subtract the minimum date_created from the maximum date_created.
 */
 
 -- Subtract the min date_created from the max
SELECT MAX(date_created) - MIN(date_created)
  FROM evanston311;


  /*
Using now(), find out how old the most recent evanston311 request was created.
 */
-- How old is the most recent request?
SELECT NOW() - MAX(date_created)
  FROM evanston311;



  /*
Add 100 days to the current timestamp.
 */

-- Add 100 days to the current timestamp
SELECT NOW() + '100 days'::INTERVAL;


  /*
Select the current timestamp and the current timestamp plus 5 minutes.
 */

-- Select the current timestamp, 
-- and the current timestamp + 5 minutes
SELECT NOW(), NOW() + '5 minutes'::INTERVAL;

  /*
Compute the average difference between the completion 
timestamp and the creation timestamp by category.

Order the results with the largest average time to 
complete the request first.
 */
 
 -- Select the category and the average completion time by category
SELECT category, 
       AVG(date_completed - date_created)  AS completion_time
  FROM evanston311
 group by category
-- Order the results
ORDER BY completion_time DESC;

-- DATE PART AND EXTRACT

/*
DATE_PART('field', TIMESTAMP) -- Uses come to separate argument
EXTRACT(FIELD FROM TIMESTAMP)  -- uses FROM to separate argument
DATE_TRUNC('field', timestamp)
*/

/*
How many requests are created in each of the 12 months during 2016-2017?
*/

-- Extract the month from date_created and count requests
SELECT DATE_PART('month', date_created) AS month, 
       COUNT(*)
  FROM evanston311
 -- Limit the date range
 WHERE date_created >= '2016-01-01'
   AND date_created <= '2018-01-01'
 -- Group by what to get monthly counts?
 GROUP BY month;
 

/*
What is the most common hour of the day for requests to be created?
*/

-- Get the hour and count requests
SELECT DATE_PART('hour', date_created) AS hour,
       count(*)
  FROM evanston311
 GROUP BY hour
 -- Order results to select most common
 ORDER BY count DESC
 LIMIT 1;
 
 
/*
During what hours are requests usually completed? 
Count requests completed by hour.

Order the results by hour.
*/

-- Count requests completed by hour
SELECT DATE_PART('hour', date_completed) AS hour,
       COUNT(*)
  FROM evanston311
 GROUP BY hour
 ORDER BY hour DESC;


/*
Select the name of the day of the week the request was created (date_created) as day.
Select the mean time between the request completion (date_completed) and request creation as duration.
Group by day (the name of the day of the week) and the integer value for the day of the week (use a function).
Order by the integer value of the day of the week using the same function used in GROUP BY.
*/

-- Select name of the day of the week the request was created 
SELECT TO_CHAR(date_created, 'day') AS day, 
       -- Select avg time between request creation and completion
       AVG(date_completed - date_created) AS duration
  FROM evanston311 
 -- Group by the name of the day of the week and 
 -- integer value of day of week the request was created
 GROUP BY day, EXTRACT(dow FROM date_created)
 -- Order by integer value of the day of the week 
 -- the request was created
 ORDER BY EXTRACT(dow FROM date_created);


/*
Write a subquery to count the number of requests created per day.
Select the month and average count per month from the daily_count subquery.
*/

-- Aggregate daily counts by month
SELECT date_trunc('month', day) AS month,
       AVG(count)
  -- Subquery to compute daily counts
  FROM (SELECT date_trunc('day', date_created) AS day,
               count(*) AS count
          FROM evanston311
         GROUP BY day) AS daily_count
 GROUP BY month
 ORDER BY month;\
 
 
/*
Write a subquery using generate_series() to get all dates between the min() and max() date_created in evanston311.
Write another subquery to select all values of date_created as dates from evanston311.
Both subqueries should produce values of type date (look for the ::).
Select dates (day) from the first subquery that are NOT IN the results of the second subquery. This gives you days that are not in date_created.
*/

SELECT day
-- 1) Subquery to generate all dates
-- from min to max date_created
  FROM (SELECT generate_series(MIN(date_created),
                               MAX(date_created),
                               '1 day')::date AS day
          -- What table is date_created in?
          FROM evanston311) AS all_dates
-- 4) Select dates (day from above) that are NOT IN the subquery
 WHERE day NOT IN 
       -- 2) Subquery to select all date_created values as dates
       (SELECT date_created::date
          FROM evanston311);


/*
Use generate_series() to create bins of 6 month intervals. Recall that the upper bin values are exclusive, so the values need to be one day greater than the last day to be included in the bin.

Notice how in the sample code, the first bin value of the upper bound is July 1st, and not June 30th.
Use the same approach when creating the last bin values of the lower and upper bounds (i.e. for 2018).
*/

-- Generate 6 month bins covering 2016-01-01 to 2018-06-30

-- Create lower bounds of bins
SELECT generate_series('2016-01-01',  -- First bin lower value
                       '2018-01-01',  -- Last bin lower value
                       '6 months'::interval) AS lower,
-- Create upper bounds of bins
       generate_series('2016-07-01',  -- First bin upper value
                       '2018-07-01',  -- Last bin upper value
                       '6 months'::interval) AS upper;



/*
Count the number of requests created per day. Remember to not count *, or you will risk counting NULL values.

Include days with no requests by joining evanston311 to a daily series from 2016-01-01 to 2018-06-30.

- Note that because we are not generating bins, you can use June 30th as your series end date.
*/

-- Count number of requests made per day 
SELECT day, count(date_created) AS count
-- Use a daily series from 2016-01-01 to 2018-06-30 
-- to include days with no requests
  FROM (SELECT generate_series('2016-01-01',  -- series start date
                               '2018-06-30',  -- series end date
                               '1 day'::interval)::date AS day) AS daily_series
       LEFT JOIN evanston311
       -- match day from above (which is a date) to date_created
       ON day = date_created::date
 GROUP BY day;
 
 
c

-- Bins from Step 1
WITH bins AS (
	 SELECT generate_series('2016-01-01',
                            '2018-01-01',
                            '6 months'::interval) AS lower,
            generate_series('2016-07-01',
                            '2018-07-01',
                            '6 months'::interval) AS upper),
-- Daily counts from Step 2
     daily_counts AS (
     SELECT day, count(date_created) AS count
       FROM (SELECT generate_series('2016-01-01',
                                    '2018-06-30',
                                    '1 day'::interval)::date AS day) AS daily_series
            LEFT JOIN evanston311
            ON day = date_created::date
      GROUP BY day)
-- Select bin bounds
SELECT lower, 
       upper, 
       -- Compute median of count for each bin
       percentile_disc(0.5) WITHIN GROUP (ORDER BY count) AS median
  -- Join bins and daily_counts
  FROM bins
       LEFT JOIN daily_counts
       -- Where the day is between the bin bounds
       ON day >= lower
          AND day < upper
 -- Group by bin bounds
 GROUP BY lower, upper
 ORDER BY lower;
 
 
 /*
Generate a series of dates from 2016-01-01 to 2018-06-30.
Join the series to a subquery to count the number of requests created per day.
Use date_trunc() to get months from date, which has all dates, NOT day.
Use coalesce() to replace NULL count values with 0. Compute the average of this value.
*/

-- generate series with all days from 2016-01-01 to 2018-06-30
WITH all_days AS 
     (SELECT generate_series('2016-01-01',
                             '2018-06-30',
                             '1 day'::interval) AS date),
     -- Subquery to compute daily counts
     daily_count AS 
     (SELECT date_trunc('day', date_created) AS day,
             count(*) AS count
        FROM evanston311
       GROUP BY day)
-- Aggregate daily counts by month using date_trunc
SELECT date_trunc('month', date) AS month,
       -- Use coalesce to replace NULL count values with 0
       avg(coalesce(count, 0)) AS average
  FROM all_days
       LEFT JOIN daily_count
       -- Joining condition
       ON all_days.date=daily_count.day
 GROUP BY month
 ORDER BY month;
 
 
  /*
Select date_created and the date_created of the previous request using lead() or lag() as appropriate.
Compute the gap between each request and the previous request.
Select the row with the maximum gap.
*/

-- Compute the gaps
WITH request_gaps AS (
        SELECT date_created,
               -- lead or lag
               lag(date_created) OVER (ORDER BY date_created) AS previous,
               -- compute gap as date_created minus lead or lag
               date_created - lag(date_created) OVER (ORDER BY date_created) AS gap
          FROM evanston311)
-- Select the row with the maximum gap
SELECT *
  FROM request_gaps
-- Subquery to select maximum gap from request_gaps
 WHERE gap = (SELECT MAX(gap)
                FROM request_gaps);


  /*
Use date_trunc() to examine the distribution of rat request completion times by number of days.
*/

-- Truncate the time to complete requests to the day
SELECT date_trunc('day', date_completed - date_created) AS completion_time,
-- Count requests with each truncated time
       COUNT(*)
  FROM evanston311
-- Where category is rats
 WHERE category = 'Rodents- Rats'
-- Group and order by the variable of interest
 GROUP BY completion_time
 ORDER BY COUNT;
 
 
   /*
Compute average completion time per category excluding the longest 5% of requests (outliers).
*/

SELECT category, 
       -- Compute average completion time per category
       AVG(date_completed - date_created ) AS avg_completion_time
  FROM evanston311
-- Where completion time is less than the 95th percentile value
 WHERE date_completed - date_created < 
-- Compute the 95th percentile of completion time in a subquery
         (SELECT percentile_disc(0.95) WITHIN GROUP (ORDER BY date_completed - date_created)
            FROM evanston311)
 GROUP BY category
-- Order the results
 ORDER BY avg_completion_time DESC;
 
 
    /*
Get corr() between avg. completion time and 
monthly requests. EXTRACT(epoch FROM interval) returns seconds in interval.
*/

-- Compute correlation (corr) between 
-- avg_completion time and count from the subquery
SELECT CORR(avg_completion, Count)
  -- Convert date_created to its month with date_trunc
  FROM (SELECT date_trunc('month', date_created) AS month, 
               -- Compute average completion time in number of seconds           
               AVG(EXTRACT(epoch FROM date_completed - date_created)) AS avg_completion, 
               -- Count requests per month
               count(*) AS count
          FROM evanston311
         -- Limit to rodents
         WHERE category='Rodents- Rats' 
         -- Group by month, created above
         GROUP BY month) 
         -- Required alias for subquery 
         AS monthly_avgs;



    /*
Select the number of requests created and number of requests completed per month.
*/

-- Compute monthly counts of requests created
WITH created AS (
       SELECT DATE_TRUNC('month', date_created) AS month,
              count(*) AS created_count
         FROM evanston311
        WHERE category='Rodents- Rats'
        GROUP BY month),
-- Compute monthly counts of requests completed
      completed AS (
       SELECT DATE_TRUNC('month', date_completed) AS month,
              count(*) AS completed_count
         FROM evanston311
        WHERE category='Rodents- Rats'
        GROUP BY month)
-- Join monthly created and completed counts
SELECT created.month, 
       created_count, 
       completed_count
  FROM created
       INNER JOIN completed
       ON created.month = completed.month
 ORDER BY created.month;