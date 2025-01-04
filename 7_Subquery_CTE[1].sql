/*

Subqueries: query nested inside a larger Query

-- It can be used in SELECT, FROM, and WHERE clauses.
*/

SELECT * FROM(-- Subquery starts here

    SELECT * FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) AS january_jobs;
-- subquery ends here

-- FOR CTE

/*
-- What is CTE: Define a temporary result set that you can 
reference 
- Can reference within a SELECT, INSERT, UPDATE, OR 
DELETE statement 
- Defined with WITH


*/

WITH january_jobs AS ( -- CTE definition starts here
SELECT *
FROM
     job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 1


) -- CTE definition  ends here


SELECT * 
FROM january_jobs


-- Example of Subquery

SELECT 

    company_id,
    job_no_degree_mention
FROM 
    job_postings_fact
WHERE
    job_no_degree_mention = true
;


-- We want the company name 



SELECT name AS Company_name

FROM company_dim;

---- Start the subquery 


 
-- Company ID

SELECT name AS Company_name,
company_id

FROM company_dim

WHERE company_id IN (

    SELECT 

        company_id
    FROM 
        job_postings_fact
    WHERE
        job_no_degree_mention = true
    )


-- Order by
ORDER BY company_id;

-- Company ID

SELECT name AS Company_name,
company_id,
link

FROM company_dim

WHERE company_id IN (

SELECT 

    company_id
FROM 
    job_postings_fact
WHERE
    job_no_degree_mention = true

ORDER BY
    company_id
)

---


SELECT 
    company_dim.name AS Company_name,
    (
        SELECT job_no_degree_mention
        FROM job_postings_fact
        WHERE job_postings_fact.company_id = company_dim.company_id
        AND job_postings_fact.job_no_degree_mention = true
        LIMIT 1
    ) AS job_no_degree_mention
FROM 
    company_dim
WHERE
    company_dim.company_id IN (
        SELECT company_id
        FROM job_postings_fact
        WHERE job_no_degree_mention = true
    );
*/


-- CTE


Find the companies that have the most job openings.
SELECT
    company_id,
    name AS company_name 
FROM company_dim; -- Get the companies

SELECT 
    company_id
FROM 
    job_postings_fact; -- Get companies with the job posted

SELECT 
    COUNT(*) AS num_of_companies,
    company_id
FROM job_postings_fact
GROUP BY company_id;

WITH company_job_count AS (
    SELECT 
        COUNT(*),
        company_id
    FROM job_postings_fact
    GROUP BY company_id
)
SELECT 
    *
FROM company_job_count;

WITH company_job_count AS (
    SELECT 
        COUNT(*),
        company_id
    FROM job_postings_fact
    GROUP BY company_id
)
SELECT 
    name
FROM company_dim cd
LEFT JOIN company_job_count cjd  
ON cjd.company_id = cd.company_id -- displays the companies
;
/*-Get the total number of 
job posting per company Id(job_posting_fact)*/
WITH company_job_count AS(
    SELECT 
        company_id,
        count(*) AS total_jobs
    FROM
        job_postings_fact
    GROUP BY
        company_id
)

SELECT
    cd.name AS company_name,
    cjc.total_jobs
FROM company_dim cd
LEFT JOIN company_job_count cjc
ON cjc.company_id = cd.company_id
ORDER BY total_jobs DESC;

- Return the total number of jobs with 
the company name (company_dim)*/


*/
SELECT 
    company_id,
    name AS Company_name 
FROm company_dim;


SELECT 
    company_id
FROM
    job_postings_fact;

-- Step 2:

SELECT 
    company_id,
    count(*)
FROM
    job_postings_fact
GROUP BY
     company_id
;

-- Step 3

WITH company_job_count AS(
    SELECT 
        company_id,
        count(*)
    FROM
        job_postings_fact
    GROUP BY
        company_id
)

SELECT *
FROM company_job_count;


-- Step 4

WITH company_job_count AS(
    SELECT 
        company_id,
        count(*)
    FROM
        job_postings_fact
    GROUP BY
        company_id
)

SELECT name 
FROM company_dim
LEFT JOIN company_job_count 
ON company_job_count.company_id = company_dim.company_id;

-- Step 5

WITH company_job_count AS(
    SELECT 
        company_id,
        count(*) AS total_jobs
    FROM
        job_postings_fact
    GROUP BY
        company_id
)

SELECT
    company_dim.name AS company_name,
    company_job_count.total_jobs
FROM company_dim
LEFT JOIN company_job_count 
ON company_job_count.company_id = company_dim.company_id;

-- Step 6 

-- using ORDER BY


SELECT name 
FROM company_dim
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id;

-- Step 5

WITH company_job_count AS(
    SELECT 
        company_id,
        count(*) AS total_jobs
    FROM
        job_postings_fact
    GROUP BY
        company_id
)

SELECT
    company_dim.name AS company_name,
    company_job_count.total_jobs
FROM company_dim
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY
    total_jobs DESC
;


SELECT *
FROM job_postings_fact;
-- What are the top-paying data analyst jobs?

SELECT
    job_title,
    salary_year_avg
FROM job_postings_fact
WHERE job_title = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;

 

SELECT *
FROM skills_dim;
SELECT
FROM skills_job_dim
LIMIT 10;
SELECT *
FROM company_dim;

-- What skills are required for these top-paying jobs?
WITH top_paying_jobs AS(
SELECT 
    job_id,
    job_title,
    salary_year_avg
FROM job_postings_fact jpf
LEFT JOIN company_dim cd
ON jpf.company_id = cd.company_id
WHERE salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
)
SELECT tpj.*, skills
FROM top_paying_jobs tpj
INNER JOIN skills_job_dim sjd 
ON tpj.job_id = sjd.job_id
INNER JOIN skills_dim sd 
ON sd.skill_id = sjd.skill_id
ORDER BY salary_year_avg DESC;


-- What skills are most in demand for data analysts?
SELECT skills, 
    COUNT(sjd.job_id) AS data_demand_skill
FROM job_postings_fact jpf
INNER JOIN skills_job_dim sjd 
ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim sd 
ON sd.skill_id = sjd.skill_id
WHERE job_title_short = 'Data Analyst' AND 
job_work_from_home = true
GROUP BY skills
ORDER BY data_demand_skill DESC
LIMIT 5;

SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim 
ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim 
ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' 
    AND job_work_from_home = True 
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;


-- Which skills are associated with higher salaries?
SELECT
    skills,
    salary_year_avg
FROM job_postings_fact jpf
INNER JOIN skills_job_dim sjd
ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim sd
ON sd.skill_id = sjd.skill_id
WHERE salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;


-- What are the most optimal skills to learn?
-- skills that are both in demand and have high
--salaries
SELECT
    sd.skill_id,
    sd.skills,
    COUNT(sjd.job_id) as skill_demand_count,
    ROUND(AVG(jpf.salary_year_avg), 0) AS avg_salary

FROM job_postings_fact jpf
INNER JOIN skills_job_dim sjd
ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim sd
ON sd.skill_id = sjd.skill_id
WHERE salary_year_avg IS NOT NULL
GROUP BY sd.skill_id
HAVING COUNT(sjd.job_id) > 10
ORDER BY avg_salary DESC, skill_demand_count DESC
LIMIT 10; 
-- What are the most optimal skills to learn as a data analyst?

SELECT 
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) 
    AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    -- AND job_work_from_home = True 
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC
    -- demand_count DESC
LIMIT 10;