
-- Change the type of firstname
ALTER TABLE professors
ALTER COLUMN firstname
TYPE VARCHAR(64);

/*
Convert types USING a function
If you don't want to reserve too much space for a certain varchar column, 
you can truncate the values before converting its type.
*/

-- Convert the values in firstname to a max. of 16 characters
ALTER TABLE professors 
ALTER COLUMN firstname 
TYPE varchar(16)
USING SUBSTRING(firstname FROM 1 FOR 16)

----------------------------------------------
-- HOW TO ADD OR REMOVE A NOT-NULL CONSTRAINT
----------------------------------------------
ALTER TABLE students
ALTER COLUMN home_phone
SET NOT NULL;

ALTER TABLE students
ALTER COLUMN ssn
DROP NOT NULL 



/*
Add a unique constraint to the university_shortname column in universities. 
Give it the name university_shortname_unq. */

-- Make universities.university_shortname unique
ALTER TABLE universities
ADD CONSTRAINT university_shortname_unq UNIQUE(university_shortname);

/*
Add a unique constraint to the organization column in organizations. 
Give it the name organization_unq. */

-- Make organizations.organization unique
ALTER TABLE organizations
ADD CONSTRAINT organization_unq UNIQUE(organization);





