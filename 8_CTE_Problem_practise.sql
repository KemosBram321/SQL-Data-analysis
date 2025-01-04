/*
Find the count of number of remote job posting per skill.
    - Display the top skills by their demand in remote jobs
    -Include skill ID, name, and count of posting requiring the skill.


*/
--- Selecting skiil_job_dim

SELECT *
FROM skills_job_dim;


-- Selecting Skills_dim

SELECT * FROM skills_dim;

-- Stage 1 - remote job posting per skill.

-- Step 1 Looking for jobs that require you to work remotely / Step 1: Retrieving Remote Jobs

SELECT 
     job_id,
     job_title_short,
     job_work_from_home
From 
    job_postings_fact
WHERE
     job_work_from_home = True
LIMIT 20   
     ;



-- Step 2: How skills are remote  / Step 2: Identifying Skills Related to Jobs


SELECT
    skill_id
FROM
     skills_job_dim AS sjd    
INNER JOIN job_postings_fact AS jpf  ON jpf.job_id = sjd.job_id
LIMIT 5
;

-- Step 3: Lets show the job_id with Skiil_id / Step 3: Linking Job IDs with Skill IDs for Remote Jobs

SELECT
    jpf.job_id,
    skill_id,
    jpf.job_work_from_home
FROM
     skills_job_dim AS sjd    
INNER JOIN job_postings_fact AS jpf  ON jpf.job_id = sjd.job_id
WHERE
    jpf.job_work_from_home = True
LIMIT 5;

-- Step 4: Let's Count the number skils 

SELECT
     
    skill_id,
    count(*) AS skill_count
     
FROM
     skills_job_dim AS sjd    
INNER JOIN job_postings_fact AS jpf  ON jpf.job_id = sjd.job_id
WHERE
    jpf.job_work_from_home = True
GROUP BY 
    skill_id
LIMIT 5;

-- Stage 2: We intriduce CTE to show we are working with remote jobs
--Step 1: Introduce CTE
WITH remote_job_skills AS (
    SELECT
     
    skill_id,
    count(*) AS skill_count
     
    FROM
        skills_job_dim AS sjd    
    INNER JOIN job_postings_fact AS jpf  ON jpf.job_id = sjd.job_id
    WHERE
        jpf.job_work_from_home = True
    GROUP BY 
        skill_id


)

SELECT * 
FROM remote_job_skills
LIMIT 5;


-- Step 2: Introduce the skill name 


WITH remote_job_skills AS (
    SELECT
    jpf.job_title_short AS Job_Name,
    skill_id,
    count(*) AS skill_count
     
    FROM
        skills_job_dim AS sjd    
    INNER JOIN job_postings_fact AS jpf  ON jpf.job_id = sjd.job_id
    WHERE
        jpf.job_work_from_home = True AND 
        jpf.job_title_short = 'Data Analyst'
    GROUP BY 
        jpf.job_title_short,
        skill_id


)

SELECT 
    Job_Name,
    sd.skill_id,
    Skills AS Skill_Name,
    skill_count
FROM remote_job_skills AS rjs
INNER JOIN skills_dim AS sd ON sd.skill_id = rjs.skill_id
ORDER BY
    skill_count DESC
LIMIT 5;
