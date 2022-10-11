SELECT COALESCE(NULL, NULL, 'companyemail', NULL, NULL, 'Example.com') AS firstNonNull_character;

-- Here 1 is the first non-null character
SELECT COALESCE(NULL, 1, 2, 5, 8) AS firstNon_null_value;