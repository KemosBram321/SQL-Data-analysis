CREATE DATABASE sql_course;

-- DROP DATABASE IF EXISTS sql_course;

CREATE DATABASE sql_course_1;
CREATE DATABASE sql_course_2;
DROP DATABASE IF EXISTS sql_course_2;

-- 1.Create a table

CREATE TABLE job_applied(
    job_id INT,
    application_sent_date DATE,
    customer_resume BOOLEAN,
    resume_file_name VARCHAR(255),
    cover_letter_sent BOOLEAN,
    cover_letter_file_name VARCHAR(255),
    status VARCHAR(50)


);

-- 2.Run Select, view the empty table 

SELECT * FROM job_applied;

-- 3. Insert data into Job applied 
INSERT INTO job_applied(
    job_id,
    application_sent_date,
    customer_resume,
    resume_file_name,
    cover_letter_sent,
    cover_letter_file_name,
    status


)
values (
    1,
    '2024-02-01',
    true,
    'resume_01.pdf',
    true,
    'cover_letter_01.pdf',
    'submitted'

),
(
    2,
    '2024-02-02',
    true,
    'resume_02.pdf',
    false,
    Null,
    'interview scheduled'

),


(
    3,
    '2024-02-03',
    true,
    'resume_0.pdf',
    True,
    'cover_letter_03.pdf',
    'ghosted'

),
(
    4,
    '2024-02-04',
    true,
    'resume_04.pdf',
    false,
    Null,
    'submitted'

),

(
    5,
    '2024-02-05',
    false,
    'resume_05.pdf',
    True,
    'cover_letter_01.pdf',
    'rejected'

);
--4.Run select, to view the data 
SELECT * FROM job_applied;


-- 5.Add a new column called Contact

ALTER TABLE job_applied
ADD contact VARCHAR(50);

-- 6.Update the new column contact with new data 
UPDATE job_applied
SET contact = 'Erlich Bachman'
WHERE job_id = 1;


UPDATE job_applied
SET contact = 'Dinesh Chugtai'
WHERE job_id = 2;

UPDATE job_applied
SET contact = 'Bertram Gilfoyle'
WHERE job_id = 3;



UPDATE job_applied
SET contact = 'Jian Yang'
WHERE job_id = 4;

UPDATE job_applied
SET contact = 'Big Head'
WHERE job_id = 5;

-- 6.1 Alternatively you can use case to update contact
UPDATE job_applied
SET contact = CASE 
    WHEN job_id = 1 THEN 'Erlich Bachman'
    WHEN job_id = 2 THEN 'Dinesh Chugtai'
    WHEN job_id = 3 THEN 'Bertram Gilfoyle'
    WHEN job_id = 4 THEN 'Jian Yang'
    WHEN job_id = 5 THEN 'Big Head'
    ELSE contact  -- keep the current value if none of the job_id matches
END
WHERE job_id IN (1, 2, 3, 4, 5);


-- 7.Rename the Contact column 

ALTER TABLE job_applied
RENAME COLUMN contact TO contact_name;

-- 8.Change contact column datatype
ALTER TABLE job_applied
ALTER COLUMN contact_name TYPE TEXT;


 
-- 9.Drop or Delete the Column 

ALTER TABLE job_applied
DROP COLUMN contact_name;

--10.Drop or Delete the table 
DROP TABLE job_applied;

 