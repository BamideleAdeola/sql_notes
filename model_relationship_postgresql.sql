/*
MODEL - RELATIONSHIP

Duplicates allowed in a foreign key 
It must reference a primary key

*/

--Adding foreign key to existing table 
ALTER TABLE a
ADD CONSTRAINT a_fkey FOREIGN KEY (b_id) REFERENCES b (id);

/*
Rename the university_shortname column to university_id in professors.
Add a foreign key on university_id column in professors that references the id column in universities.
Name this foreign key professors_fkey.
*/

-- Rename the university_shortname column
ALTER TABLE professors
RENAME COLUMN university_shortname TO university_id;
-- Add a foreign key on professors referencing universities
ALTER TABLE professors 
ADD CONSTRAINT professors_fkey FOREIGN KEY (university_id) REFERENCES universities (id);


/*
JOIN professors with universities on professors.university_id = universities.id, 
i.e., retain all records where the foreign key of professors is equal to the
primary key of universities.
Filter for university_city = 'Zurich'.
*/

-- Select all professors working for universities in the city of Zurich
SELECT professors.lastname, universities.id, universities.university_city
FROM professors
JOIN universities
ON professors.university_id = universities.id
WHERE universities.university_city = 'Zurich';


--------------------------------------------------
/*
1.Add a professor_id column with integer data type to affiliations, 
and declare it to be a foreign key that references the id column in professors.
2. Rename the organization column in affiliations to organization_id.
3. Add a foreign key constraint on organization_id so that it references the id column in organizations.
*/

-- Add a professor_id column
ALTER TABLE affiliations
ADD COLUMN professor_id integer REFERENCES professors (id);

-- Rename the organization column to organization_id
ALTER TABLE affiliations
RENAME organization TO organization_id;

-- Add a foreign key on organization_id
ALTER TABLE affiliations
ADD CONSTRAINT affiliations_organization_fkey FOREIGN KEY (organization_id) REFERENCES organizations (id);

/*
Update the professor_id column with the corresponding value of the id column in professors.
"Corresponding" means rows in professors where the firstname and lastname are identical to the ones in affiliations.
*/

-- Set professor_id to professors.id where firstname, lastname correspond to rows in professors
UPDATE affiliations
SET professor_id = professors.id
FROM professors
WHERE affiliations.firstname = professors.firstname AND affiliations.lastname = professors.lastname;


/*
Drop the firstname and lastname columns from the affiliations table.
*/

-- Drop the firstname column
ALTER TABLE affiliations
DROP COLUMN firstname;

-- Drop the lastname column
ALTER TABLE affiliations
DROP COLUMN lastname;