/*
Answer: What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Scientist positions.
- Focuses on rules with specified salaries, regardless of location.
- Why? It reveals how different skills impact salary levels for data Scientists and 
	helps identify the most financially rewarding skills to acquire or improve.
*/

SELECT 
    skills,
    ROUND(AVG(salary_year_avg) ,0) AS Average_salary

FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Scientist' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
  Average_salary DESC
LIMIT 25;

/*
Here;s a breakdown of the results for top paying skills for Data Scientists in 2023:
Specialized skills lead: GDPR, Golang, and Atlassian stand out with the highest average salaries, showing the value of specialized technical and compliance expertise.
Advanced technical skills follow: Selenium, OpenCV, Neo4j, and cloud/database technologies highlight the importance of automation, AI, and scalable data systems.
Broad skill diversity: The dataset includes programming, analytics, databases, BI, cloud, and AI skills, demonstrating that diverse technical expertise can contribute to higher earning potential.
[
  {
    "skills": "gdpr",
    "average_salary": "217738"
  },
  {
    "skills": "golang",
    "average_salary": "208750"
  },
  {
    "skills": "atlassian",
    "average_salary": "189700"
  },
  {
    "skills": "selenium",
    "average_salary": "180000"
  },
  {
    "skills": "opencv",
    "average_salary": "172500"
  },
  {
    "skills": "neo4j",
    "average_salary": "171655"
  },
  {
    "skills": "microstrategy",
    "average_salary": "171147"
  },
  {
    "skills": "dynamodb",
    "average_salary": "169670"
  },
  {
    "skills": "php",
    "average_salary": "168125"
  },
  {
    "skills": "tidyverse",
    "average_salary": "165513"
  },
  {
    "skills": "solidity",
    "average_salary": "165000"
  },
  {
    "skills": "c",
    "average_salary": "164865"
  },
  {
    "skills": "go",
    "average_salary": "164691"
  },
  {
    "skills": "datarobot",
    "average_salary": "164500"
  },
  {
    "skills": "qlik",
    "average_salary": "164485"
  },
  {
    "skills": "redis",
    "average_salary": "162500"
  },
  {
    "skills": "watson",
    "average_salary": "161710"
  },
  {
    "skills": "rust",
    "average_salary": "161250"
  },
  {
    "skills": "elixir",
    "average_salary": "161250"
  },
  {
    "skills": "cassandra",
    "average_salary": "160850"
  },
  {
    "skills": "looker",
    "average_salary": "158715"
  },
  {
    "skills": "slack",
    "average_salary": "158333"
  },
  {
    "skills": "terminal",
    "average_salary": "157500"
  },
  {
    "skills": "airflow",
    "average_salary": "157414"
  },
  {
    "skills": "julia",
    "average_salary": "157244"
  }
]
*/
