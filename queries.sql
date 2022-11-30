--Query 1 
--Get number of unique crash types (dph_col_grp & dph_col_grp_description)
USE ACCIDENTS_SF;

SELECT COUNT(*) AS crash_type_count
FROM
(SELECT DISTINCT dph_col_grp_description
FROM CRASH_TYPE) crash_type_data;


--Query 2 
--Get number of crashes for each crash type (dph_col_grp & dph_col_grp_description).
--Order by number of crashes
USE ACCIDENTS_SF;

CREATE VIEW crashes_with_type AS 
SELECT crash.crash_unique_id, crash.dph_col_grp, crash_type.dph_col_grp_description
FROM crash
INNER JOIN crash_type
ON crash.dph_col_grp = crash_type.dph_col_grp;

SELECT dph_col_grp,ANY_VALUE(dph_col_grp_description), count(crash_unique_id) as crash_count
FROM crashes_with_type
GROUP BY dph_col_grp;


--Query 3 
--Get majority crash type (dph_col_grp & dph_col_grp_description) in each year.

USE ACCIDENTS_SF;

CREATE VIEW crashes_with_type2 AS 
SELECT crash.crash_unique_id, crash.accident_year, crash.dph_col_grp, crash_type.dph_col_grp_description
FROM crash
INNER JOIN crash_type
ON crash.dph_col_grp = crash_type.dph_col_grp;

SELECT accident_year, ANY_VALUE(dph_col_grp_description)
FROM (SELECT dph_col_grp_description, accident_year from crashes_with_type2
GROUP BY dph_col_grp_description, accident_year
ORDER BY count(accident_year) desc) year_count where year_count.dph_col_grp_description = dph_col_grp_description
GROUP BY accident_year;


--Query 4 
--Get total number killed & number of crashes from each crash type (dph_col_grp & dph_col_grp_description).

USE ACCIDENTS_SF;

CREATE VIEW crashes_with_type3 AS 
SELECT crash.crash_unique_id, crash.number_killed, crash.dph_col_grp, crash_type.dph_col_grp_description
FROM crash
INNER JOIN crash_type
ON crash.dph_col_grp = crash_type.dph_col_grp;

SELECT dph_col_grp_description, ROUND(SUM(number_killed),0) AS total_number_killed, COUNT(dph_col_grp_description) AS total_crashes
FROM crashes_with_type3
GROUP BY dph_col_grp_description;


--Query 5
--Get total number of crash victims.

USE ACCIDENTS_SF;

CREATE VIEW crashes_with_victims AS 
SELECT crash.crash_unique_id, crash.case_id_pkey, victims.victim_id
FROM crash
INNER JOIN victims
ON crash.case_id_pkey = victims.case_id_pkey;

SELECT COUNT(*) AS total_victims
FROM
(SELECT DISTINCT victim_id
FROM crashes_with_victims) total_victims_data;



--Query 6
--Get total number of victims in each year.

USE ACCIDENTS_SF;

CREATE VIEW crashes_with_victims2 AS 
SELECT crash.crash_unique_id, crash.case_id_pkey, crash.accident_year, victims.victim_id
FROM crash
INNER JOIN victims
ON crash.case_id_pkey = victims.case_id_pkey;

SELECT accident_year, COUNT(DISTINCT victim_id) as total_victims
FROM crashes_with_victims2
GROUP BY accident_year


--Get majority victim gender in each year.

USE ACCIDENTS_SF;

CREATE VIEW crashes_with_victims3 AS 
SELECT crash.case_id_pkey, crash.accident_year, victims.victim_id, victims.victim_sex
FROM crash
INNER JOIN victims
ON crash.case_id_pkey = victims.case_id_pkey;

SELECT accident_year, ANY_VALUE(victim_sex)
FROM (SELECT victim_sex, accident_year from crashes_with_victims3
GROUP BY victim_sex, accident_year
ORDER BY count (accident_year) desc) year_count where year_count.victim_sex = victim_sex
GROUP BY accident_year


 
