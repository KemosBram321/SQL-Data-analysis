-- Get jobs and companies from January 

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION

-- Get jobs and companies from February

SELECT 
    job_title_short,
    company_id,
    job_location

FROM
    february_jobs

-- Get jobs and companies from March

UNION

SELECT 
    job_title_short,
    company_id,
    job_location

FROM
    march_jobs;


-- using UNION ALL


-- Get jobs and companies from January 

SELECT
    job_title_short,
    company_id,
    job_location
FROM
    january_jobs

UNION ALL

-- Get jobs and companies from February

SELECT 
    job_title_short,
    company_id,
    job_location

FROM
    february_jobs

-- Get jobs and companies from March

UNION ALL

SELECT 
    job_title_short,
    company_id,
    job_location

FROM
    march_jobs;


/*

Find job posting from the first quarter that have a salary greater than $ 70k.
- Combine job posting tables from the first quarter
- Gets job posting with an average yearly salary > $ 70,000


*/

SELECT *
FROM(
    SELECT *
    FROM january_jobs

    UNION ALL

    SELECT *
    FROM february_jobs

    UNION ALL
    SELECT *
    FROM march_jobs
) AS quarter1_job_postings


SELECT 
quarter1_job_postings.job_title_short,
quarter1_job_postings.job_location,
quarter1_job_postings.job_via,
quarter1_job_postings.job_posted_date :: date
FROM(
    SELECT *
    FROM january_jobs

    UNION ALL

    SELECT *
    FROM february_jobs

    UNION ALL
    SELECT *
    FROM march_jobs
) AS quarter1_job_postings

WHERE
    salary_year_avg > 7000 AND 
    job_title_short = 'Data Analyst'
    ORDER BY 
        salary_year_avg DESC
    ;

--- Without adding the alies quarter1_job_postings


SELECT 
job_title_short,
job_location,
job_via,
job_posted_date :: date
FROM(
    SELECT *
    FROM january_jobs

    UNION ALL

    SELECT *
    FROM february_jobs

    UNION ALL
    SELECT *
    FROM march_jobs
) AS quarter1_job_postings

WHERE
    salary_year_avg > 7000 AND 
    job_title_short = 'Data Analyst'
    ORDER BY 
        salary_year_avg DESC
    ;


 

 
-- Using CTE

    
WITH quarter1_job_postings AS (
    SELECT 
        job_title_short,
        job_location,
        job_via,
        job_posted_date :: DATE,
        salary_year_avg
    FROM january_jobs

    UNION ALL

    SELECT 
        job_title_short,
        job_location,
        job_via,
        job_posted_date :: DATE,
        salary_year_avg
    FROM february_jobs

    UNION ALL

    SELECT 
        job_title_short,
        job_location,
        job_via,
        job_posted_date :: DATE,
        salary_year_avg
    FROM march_jobs
),

remote_job_skills AS (
    SELECT
        jpf.job_title_short AS Job_Name,
        skill_id,
        COUNT(*) AS skill_count
    FROM
        skills_job_dim AS sjd    
    INNER JOIN job_postings_fact AS jpf ON jpf.job_id = sjd.job_id
    WHERE
        jpf.job_work_from_home = TRUE 
        AND jpf.job_title_short = 'Data Analyst'
    GROUP BY 
        jpf.job_title_short,
        skill_id
)

-- Combine results from both CTEs
SELECT 
    qp.job_title_short AS Job_Title,
    qp.job_location AS Job_Location,
    qp.salary_year_avg AS Salary,
    sd.skill_id AS Skill_ID,
    sd.skills AS Skill_Name,
    rjs.skill_count AS Skill_Importance
FROM 
    quarter1_job_postings AS qp
LEFT JOIN remote_job_skills AS rjs ON rjs.Job_Name = qp.job_title_short
LEFT JOIN skills_dim AS sd ON sd.skill_id = rjs.skill_id
WHERE
    qp.salary_year_avg > 70000 -- Filter high-salary Data Analyst jobs
    AND qp.job_title_short = 'Data Analyst'
ORDER BY 
    qp.salary_year_avg ASC, -- Prioritize by salary
    rjs.skill_count DESC     -- Then prioritize by skill importance
LIMIT 50; -- Top 10 results


