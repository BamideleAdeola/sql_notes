
--------------------------
-- Q1 Get information on all table names in the current database, while limiting your query to the 'public' table_schema.
--------------------------

SELECT table_name
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'public';


--------------------------
--Q2 Now have a look at the columns in university_professors by selecting all entries in information_schema.columns that correspond to that table.
--------------------------
-- Query the right table in information_schema to get columns
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'university_professors' AND table_schema = 'public';

--------------------------
--Q3 How many columns does the table university_professors have?
--------------------------

SELECT COUNT(column_name) 
FROM information_schema.columns 
WHERE table_name = 'university_professors' AND table_schema = 'public';

--------------------------
--Q4 Finally, print the first five rows of the university_professors table.
--------------------------
-- Query the first five rows of our table IN pOSTGREsql
SELECT * 
FROM university_professors 
LIMIT 5;

-- In SQL Server
SELECT TOP (5) * 
FROM Album;

--CREATING TABLE

CREATE TABLE universities(
    university_shortname text,
    university text,
    university_city text
);

-- ADD a COLUMN with ALTER TABLE

------------------------------------
-- Q5 Alter professors to add the text column university_shortname.
------------------------------------
-- Add the university_shortname column
ALTER TABLE professors
ADD COLUMN university_shortname text;

-- Print the contents of this table
SELECT * 
FROM professors

-- One can use the Insert into function to migrate data into another table
INSERT INTO organizations
SELECT DISTINCT organization,
	organization_sector
FROM university_professors;


-- RENAME
---------------------------------------
-- Q6 Rename the organisation column to organization in affiliations.
-- Delete the university_shortname column in affiliations.
---------------------------------------
-- Rename the organisation column
ALTER TABLE affiliations
RENAME COLUMN organisation TO organization;

-- Delete the university_shortname column
ALTER TABLE affiliations
DROP COLUMN university_shortname;


-----------------------------------------------
-- Migrate data with INSERT INTO SELECT DISTINCT
-----------------------------------------------

/*Q7
Insert all DISTINCT professors from university_professors into professors.
Print all the rows in professors.
*/
-- Insert unique professors into the new table
INSERT INTO professors 
SELECT DISTINCT firstname, lastname, university_shortname 
FROM university_professors;

-- Doublecheck the contents of professors
SELECT * 
FROM professors;


/*Q8
Insert all DISTINCT affiliations into affiliations from university_professors.
*/

-- Insert unique affiliations into the new table
INSERT INTO affiliations 
SELECT DISTINCT firstname, lastname, function, organization 
FROM university_professors;

-- Doublecheck the contents of affiliations
SELECT * 
FROM affiliations;



-----------------------------------------------
-- Delete tables with DROP TABLE
-----------------------------------------------

/* Q9
Delete the university_professors table.
*/

-- Delete the university_professors table
DROP TABLE university_professors;

