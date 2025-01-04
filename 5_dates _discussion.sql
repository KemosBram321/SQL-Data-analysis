-- Retrieve all columns from the job_postings_fact table
SELECT * FROM job_postings_fact;

-- Select only the job_posted_date column and limit the result to 10 rows
SELECT job_posted_date 
FROM job_postings_fact
LIMIT 10;

-- Example of casting strings to different data types
SELECT '2023-02-19':: DATE;

SELECT 
    '2023-02-19':: DATE,  -- Converts string to DATE type
    '123':: INTEGER,      -- Converts string to INTEGER type
    'true':: BOOLEAN,     -- Converts string to BOOLEAN type
    '3.24':: REAL;        -- Converts string to REAL (floating-point number) type

-- Retrieve specific columns with aliases for readability
SELECT 
    job_title_short AS Title,  -- Renames job_title_short to Title
    job_location AS location,  -- Renames job_location to location
    job_posted_date AS date    -- Renames job_posted_date to date
FROM 
    job_postings_fact;

-- Casting job_posted_date to DATE type, if it's originally of a different type
SELECT 
    job_title_short AS Title,
    job_location AS location,
    job_posted_date:: DATE AS date
FROM 
    job_postings_fact;

-- Retrieve rows with timezone conversion and limit to 5 rows
SELECT 
    job_title_short AS Title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EAT' AS date  -- Adjusts the timezone to East Africa Time
FROM 
    job_postings_fact
LIMIT 5;

-- Extract the month from job_posted_date
SELECT 
    job_title_short AS Title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EAT' AS date,
    EXTRACT(MONTH FROM job_posted_date) AS date_month  -- Extracts the month from job_posted_date
FROM 
    job_postings_fact
LIMIT 5;

-- Extract both month and year from job_posted_date for additional time analysis
SELECT 
    job_title_short AS Title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EAT' AS date,
    EXTRACT(MONTH FROM job_posted_date) AS date_month,
    EXTRACT(YEAR FROM job_posted_date) AS date_year  -- Extracts the year from job_posted_date
FROM 
    job_postings_fact
LIMIT 5;

-- Identify job trends by extracting the month from job_posted_date
SELECT
    job_id,
    EXTRACT(MONTH FROM job_posted_date) AS date_month
FROM
    job_postings_fact
LIMIT 5;

-- Count jobs by month to analyze monthly posting trends
SELECT
    COUNT(job_id),                       -- Counts job postings per month
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM
    job_postings_fact
GROUP BY
    month
LIMIT 5;

-- Analyze trends specifically for Data Analyst job postings by month
SELECT
    COUNT(job_id),
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'     -- Filters for Data Analyst jobs
GROUP BY
    month
ORDER BY
    month ASC;                           -- Orders by month in ascending order
/*

Summary

This SQL script effectively covers multiple aspects:

    Data retrieval and column aliasing for clarity
    Typecasting and date formatting
    Time zone adjustments
    Date extraction (month and year) for trend analysis
    Aggregation by month with filtering for specific job titles



*/