--Project: SQL Murder Mystery
--In this project, I worked on solving a crime case using a real-world inspired database (sql-murder-mystery.db). The challenge required retrieving and analyzing structured data with SQL to identify the murderer and the person who hired them.
--To solve the case, I used different SQL techniques, conditions, and functions step by step:


-- Filtering with Conditions (WHERE)
-- I began by narrowing down the dataset using conditions such as date (2018-01-15) and city (SQL City) to locate the crime scene report.
SELECT*
FROM crime_scene_report
WHERE type = 'murder'
AND city = 'SQL City'
and date = 20180115
--RESULT: Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin Ave".

-- Using DESC, LIMIT and String Matching (LIKE) i was able to get their full information
-- 1st- lives at the last house on "Northwestern Dr".
SELECT*
FROM person
WHERE address_street_name = 'Northwestern Dr'
ORDER by address_number DESC
LIMIT 1
--RESULT: id= 14887, name= Morty Schapiro

-- 2nd- Annabel, lives somewhere on "Franklin Ave".
SELECT*
FROM person
WHERE address_street_name = 'Franklin Ave'
AND name like '%Ann%'
--RESULT: id= 16371, name= Annabel Miller

--Using the WHERE function to filter person_id table and IN function to combine the two id
SELECT*
FROM interview
where person_id IN(14887, 16371)
--RESULTS:
--14887 "I heard a gunshot and then saw a man run out. He had a ""Get Fit Now Gym"" bag. The membership number on the bag started with ""48Z"". Only gold members have those bags. The man got into a car with a plate that included ""H42W"
--16371	"I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th."

-- Exploring Data with Joins(JOIN) 
-- By joining multiple tables (e.g., crime_scene_report, person, interview, etc.), I was able to connect suspects, their backgrounds, and testimonies to piece together leads.
-- CLUE FROM THE 2 WITNESSES :"Get fit now gym" bag started with "48Z"
--"car with a plate that include "H42W"
--"my gym last week on January the 9th.
SELECT p.*, gf.*
FROM drivers_license as dl
INNER JOIN person as p on dl.id = p.license_id
INNER JOIN get_fit_now_member as gf on p.id = gf.person_id
INNER JOIN get_fit_now_check_in as ci on gf.id = ci.membership_id
WHERE plate_number like '%H42W%'
And check_in_date = 20180109
LIMIT 10
--RESULT: id= 67318, name= Jeremy Bowers

--Jeremy Bowers interview
SELECT*
from interview 
where person_id = 67318
--RESULT: I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017.

--From Jeremy Bowers' statement
with CTE as (
SELECT person_id, COUNT(*) as visits
from facebook_event_checkin
where date BETWEEN 20171201 and 20171231
and event_name = 'SQL Symphony Concert'
GROUP by person_id
HAVING COUNT(*) >=3
)
--Using INNRR JOIN
SELECT p.*, fb.*
FROM drivers_license as dl
INNER JOIN person as p on dl.id = p.license_id
INNER join facebook_event_checkin as fb on fb.person_id = p.id
where hair_color = 'red'
and height >= 65
and height <= 67
and car_make LIKE '%tesla%'
LIMIT 10
--RESULT= id= 99716, name= Miranda Priestly i.e THE MASTERMIND

--Step-by-Step Deduction
--By following the digital “paper trail” in the database—crime scene reports, witness interviews, gym records, and financial transactions—I was able to identify the murderer and uncover the mastermind who hired them.

--Outcome
--Through structured queries and logical deduction, I successfully solved the case, demonstrating how SQL can be applied beyond theory—into problem-solving and investigative analytics.
--This project showcased my ability to:Analyze complex datasets.
-- Apply SQL joins, conditions, and functions effectively.
-- Break down a problem into smaller steps and derive actionable insights.




