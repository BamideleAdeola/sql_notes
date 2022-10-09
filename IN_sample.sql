 -- THE IN OPERATOR
 
/* Challenge
From the 71 Distinct movie titles in the movie database,
Retrieve all records for the titles 'Showtime', 'Love Actually', 'The Fighter'
*/


-- Approach 1: Please try to avoid this approach as much as possible
SELECT *
FROM movies
WHERE title = 'Showtime'
OR title = 'Love Actually'
OR title = 'The Fighter';



-- Approach 2: The IN operator is the best in this scenario
SELECT *
FROM movies
WHERE title IN ('Showtime', 
				'Love Actually', 
				'The Fighter'); -- Select all movies with the given titles

