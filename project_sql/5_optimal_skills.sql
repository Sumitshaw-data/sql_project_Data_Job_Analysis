/*
Answer: What are the most optimal skills to learn (aka it's in high demand and a high paying skills)?
- Identify skills in high demand and associated with high average salaries for data Scientist roles
- Concentrates on remote positions with specified salaries
- Why? Target skills that offer job security (high demand) and financial benefits (high salaries), 
	offering strategic insights for career development in data science.
*/

WITH skills_demand AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.skill_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Scientist' 
        AND salary_year_avg IS NOT NULL 
        AND job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id
),
average_salary AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        ROUND(AVG(salary_year_avg) ,0) AS Average_salary

    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Scientist' AND
        salary_year_avg IS NOT NULL AND
        job_work_from_home = TRUE
    GROUP BY
     skills_dim.skill_id

)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    average_salary
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE   
    demand_count > 10
ORDER BY
    average_salary DESC,
    demand_count DESC
LIMIT 25;

-- Rewriting this same query more concisely

SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    Count(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Scientist'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True
GROUP BY

    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    average_salary DESC,
    demand_count DESC
LIMIT 25;

/*
Here's a breakdown of the most optimal skills for Data Scientists in 2023:
High-value specialized skills: C, Go, and Qlik offer the highest average salaries, highlighting the value of specialized programming and analytics expertise.
Strong demand for core technologies: Python, Tableau, Spark, AWS, and TensorFlow are among the more frequently required skills, showing their importance across Data Science roles.
Balanced technical skill set: The dataset emphasizes programming, cloud platforms, machine learning, databases, and visualization, reflecting the broad technical expertise expected in the field.
[
  {
    "skill_id": 26,
    "skills": "c",
    "demand_count": "48",
    "average_salary": "164865"
  },
  {
    "skill_id": 8,
    "skills": "go",
    "demand_count": "57",
    "average_salary": "164691"
  },
  {
    "skill_id": 187,
    "skills": "qlik",
    "demand_count": "15",
    "average_salary": "164485"
  },
  {
    "skill_id": 185,
    "skills": "looker",
    "demand_count": "57",
    "average_salary": "158715"
  },
  {
    "skill_id": 96,
    "skills": "airflow",
    "demand_count": "23",
    "average_salary": "157414"
  },
  {
    "skill_id": 77,
    "skills": "bigquery",
    "demand_count": "36",
    "average_salary": "157142"
  },
  {
    "skill_id": 3,
    "skills": "scala",
    "demand_count": "56",
    "average_salary": "156702"
  },
  {
    "skill_id": 81,
    "skills": "gcp",
    "demand_count": "59",
    "average_salary": "155811"
  },
  {
    "skill_id": 80,
    "skills": "snowflake",
    "demand_count": "72",
    "average_salary": "152687"
  },
  {
    "skill_id": 101,
    "skills": "pytorch",
    "demand_count": "115",
    "average_salary": "152603"
  },
  {
    "skill_id": 78,
    "skills": "redshift",
    "demand_count": "36",
    "average_salary": "151708"
  },
  {
    "skill_id": 99,
    "skills": "tensorflow",
    "demand_count": "126",
    "average_salary": "151536"
  },
  {
    "skill_id": 233,
    "skills": "jira",
    "demand_count": "22",
    "average_salary": "151165"
  },
  {
    "skill_id": 92,
    "skills": "spark",
    "demand_count": "149",
    "average_salary": "150188"
  },
  {
    "skill_id": 76,
    "skills": "aws",
    "demand_count": "217",
    "average_salary": "149630"
  },
  {
    "skill_id": 94,
    "skills": "numpy",
    "demand_count": "73",
    "average_salary": "149089"
  },
  {
    "skill_id": 106,
    "skills": "scikit-learn",
    "demand_count": "81",
    "average_salary": "148964"
  },
  {
    "skill_id": 95,
    "skills": "pyspark",
    "demand_count": "34",
    "average_salary": "147544"
  },
  {
    "skill_id": 182,
    "skills": "tableau",
    "demand_count": "219",
    "average_salary": "146970"
  },
  {
    "skill_id": 2,
    "skills": "nosql",
    "demand_count": "31",
    "average_salary": "146110"
  },
  {
    "skill_id": 4,
    "skills": "java",
    "demand_count": "64",
    "average_salary": "145706"
  },
  {
    "skill_id": 196,
    "skills": "powerpoint",
    "demand_count": "23",
    "average_salary": "145139"
  },
  {
    "skill_id": 93,
    "skills": "pandas",
    "demand_count": "113",
    "average_salary": "144816"
  },
  {
    "skill_id": 213,
    "skills": "kubernetes",
    "demand_count": "25",
    "average_salary": "144498"
  },
  {
    "skill_id": 1,
    "skills": "python",
    "demand_count": "763",
    "average_salary": "143828"
  }
]
*/

