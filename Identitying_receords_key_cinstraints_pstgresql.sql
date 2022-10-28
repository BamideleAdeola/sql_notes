/*
UNIQUELY IDENTIFYING RECORDS WITH KEY CONSTRAINTS
*/

/* Q1
Rename the organization column to id in organizations.
Make id a primary key and name it organization_pk.
*/

-- Rename the organization column to id
ALTER TABLE organizations
RENAME COLUMN organization TO id;

-- Make id a primary key
ALTER TABLE organizations
ADD CONSTRAINT organization_pk PRIMARY KEY (id);

/* Q2
Rename the university_shortname column to id in universities.
Make id a primary key and name it university_pk
*/
-- Rename the university_shortname column to id
ALTER TABLE universities
RENAME COLUMN university_shortname TO id;

-- Make id a primary key
ALTER TABLE universities
ADD CONSTRAINT university_pk PRIMARY KEY (id);

------------------------------------------
-- SURROGATE KEYS - Add a SERIAL surrogate key
------------------------------------------
ALTER TABLE cars
ADD COLUMN id SERIAL PRIMARY KEY;

--Combining 2 existing keys for surrogate column
ALTER TABLE table_name
ADD COLUMN column_c VARCHAR(256);

UPDATE table_name
SET column_c = CONCAT(column_a, column_b);

ALTER TABLE table_name
ADD CONSTRAINT pk PRIMARY KEY (column_c);

----------------------------------------------------------------------------
--Add a new column id with data type serial to the professors table.
--Make id a primary key and name it professors_pkey.
--Write a query that returns all the columns and 10 rows from professors.
----------------------------------------------------------------------------

-- Add the new column to the table
ALTER TABLE professors 
ADD COLUMN id serial;

-- Make id a primary key
ALTER TABLE professors 
ADD CONSTRAINT professors_pkey PRIMARY KEY (id);

-- Have a look at the first 10 rows of professors
SELECT * FROM professors
LIMIT 10;

----------------------------------------------------------------------------
/*
--CONCATenate columns to a surrogate key

1. Count the number of distinct rows with a combination of the make and model columns.
2. Add a new column id with the data type varchar(128).
3. Concatenate make and model into id using an UPDATE table_name SET column_name = ... query and the CONCAT() function.
4. Make id a primary key and name it id_pk.
*/
----------------------------------------------------------------------------

-- Count the number of distinct rows with columns make, model
SELECT COUNT(DISTINCT(make, model)) 
FROM cars;

-- Add the id column
ALTER TABLE cars
ADD COLUMN id varchar(128);

-- Update id with make + model
UPDATE cars
SET id = CONCAT(make, model);

-- Make id a primary key
ALTER TABLE cars
ADD CONSTRAINT id_pk PRIMARY KEY(id);

-- Have a look at the table
SELECT * FROM cars;


----------------------------------------------------------------------------
/* 
Given the above description of a student entity, create a table students with the correct column types.
Add a PRIMARY KEY for the social security number ssn.
Note that there is no formal length requirement for the integer column. The application would have to make sure it's a correct SSN!
*/
----------------------------------------------------------------------------
-- Create the table
CREATE TABLE students (
  last_name VARCHAR(128) NOT NULL,
  ssn INTEGER PRIMARY KEY,
  phone_no CHAR(12)
);
