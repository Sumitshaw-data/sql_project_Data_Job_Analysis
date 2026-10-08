# Introduction
📊 Dive into the data science job market! Focusing on remote Data Scientist roles, this project explores 💰 top-paying jobs, 🔥 in-demand skills, and 📈 where high demand intersects with top-tier compensation in modern data science.
# Background
Driven by a quest to navigate the competitive data science landscape, this project pinpoints high-paying and high-demand skills to guide strategic learning and career development.
### Data Source
The dataset used in this project is sourced from Luke Barousse’s SQL Course and powers his job analytics platform, [datanerd.tech](https://datanerd.tech). 
### Core Business Questions:
1. What are the top-paying Data Scientist jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for Data Scientists?
4. Which skills command the highest average salaries?
5. What are the most optimal skills to learn (high demand + high salary)?

# Tools I Used
* **SQL:** The core language used to query, aggregate, and extract insights.
* **PostgreSQL:** Relational database management system storing the job posting data.
* **Visual Studio Code:** Integrated development environment used for writing queries and Git workflow.
* **Git & GitHub:** For version control, documentation, and sharing findings.

# The Analysis
### 1. Top-Paying Data Scientist Jobs
Filtering for remote Data Scientist positions with explicit salary information to identify the highest earning potentials:

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Scientist' AND 
    job_location = 'Anywhere' AND 
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```
**Key Finding:** Top-paying Data Scientist positions frequently exceed $250,000–$350,000+ per year, often concentrated in specialized machine learning, AI, and big-data roles.
![Top Paying Roles](assets\1_top_paying_roles.png)
*Bar graph visualising the salary for the top 10 salaries for data scientists; Google gemini generated this graph from my SQL query results*
### 2. Skills for Top-Paying Jobs
​Using a CTE to isolate the skills requested across those top 10 highest-paying roles:
```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Scientist' AND 
        job_location = 'Anywhere' AND 
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)
SELECT 
    top_paying_jobs.*,
    skills_dim.skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC;
```
**Key Finding:** Python, AWS, PyTorch, and SQL dominate the top compensation tiers, showing that elite compensation goes to roles bridging analytical modeling and cloud production.
![Top Paying Skills](assets\2_top_paying_roles_skills.png)
*Bar graph visualizing the count of skills for the top 10 paying jobs for data scientists; Google gemini generated this graph from my SQL query results*
### ​3. Most In-Demand Skills for Data Scientists
​Aggregating mentions across all remote Data Scientist postings to measure overall market demand:
```sql
SELECT 
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Scientist' AND
    job_work_from_home = TRUE
GROUP BY
    skills_dim.skills
ORDER BY
    demand_count DESC
LIMIT 10;
```
![Top Paying Skills](assets\3_top_paying_skills.png)
*Bar graph visualising the top demanded skills for data scientists based
on the job postings data of 2023; Gemini generated this graph from my SQL query results*
### ​4. Top-Paying Skills
​Finding which specific skills command the highest average salary:
```sql
SELECT 
    skills_dim.skills,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Scientist' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = TRUE
GROUP BY
    skills_dim.skills
ORDER BY
    avg_salary DESC
LIMIT 25;
```
| Skill | Average Salary ($) |
| :--- | :---: |
| **GDPR** | $217,738 |
| **Golang** | $208,750 |
| **Atlassian** | $189,700 |
| **Selenium** | $180,000 |
| **OpenCV** | $172,500 |
| **Neo4j** | $171,655 |
| **MicroStrategy** | $171,147 |
| **DynamoDB** | $169,670 |
| **PHP** | $168,125 |
| **Tidyverse** | $165,513 |

*Table highlights the top 10 highest-paying skills for Data Scientists, revealing that regulatory compliance, backend engineering, and niche modeling frameworks command the highest salary premiums.*

### Here's a breakdown of the results for top-paying skills for Data Scientists:
- **High Demand for Data Governance & Security:** Top salaries are commanded by specialists knowledgeable in regulatory frameworks like GDPR ($217,738), reflecting how heavily enterprise organizations prioritize data compliance, privacy auditing, and risk management when deploying production models.
- **​Production-Grade Software Engineering:** Languages and frameworks that facilitate high-scale backend delivery—such as Golang ($208,750), Selenium ($180,000), and DynamoDB ($169,670)—demonstrate a strong compensation premium for data scientists who can take models from notebooks into production-ready software systems.
- **​Specialized Niche Domains (Vision & Graph Technologies):** Expertise in computer vision (OpenCV at $172,500) and graph data architecture (Neo4j at $171,655) outperforms standard tools, confirming that deep technical specialization in distinct algorithmic domains yields significantly higher salaries.
### 5. Optimal Skills (High Demand & High Salary)
​Combining demand and salary thresholds to find the highest-ROI skills to master
```sql
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Scientist' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = TRUE
GROUP BY
    skills_dim.skill_id,
    skills_dim.skills
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```
| Skill ID | Skill | Demand Count | Average Salary ($) |
| :---: | :--- | :---: | :---: |
| 26 | **C** | 48 | $164,865 |
| 8 | **Go** | 57 | $164,691 |
| 187 | **Qlik** | 15 | $164,485 |
| 185 | **Looker** | 57 | $158,715 |
| 96 | **Airflow** | 23 | $157,414 |
| 77 | **BigQuery** | 36 | $157,142 |
| 3 | **Scala** | 56 | $156,702 |
| 81 | **GCP** | 59 | $155,811 |
| 80 | **Snowflake** | 72 | $152,687 |
| 101 | **PyTorch** | 115 | $152,603 |

*Table highlights the top 10 optimal skills for Data Scientists sorted by average salary, showcasing the balance between high-demand tooling and top compensation.*
### Here's a breakdown of the results for the most optimal skills for Data Scientists:

* **High-Performance Programming at Scale:** Systems and compiled languages like C ($164,865) and Go ($164,691), alongside Scala ($156,702), lead the salary rankings, emphasizing a strong premium for data scientists capable of low-level optimization, high-throughput systems, and production-grade execution.
* **Modern Cloud Data Warehousing & Workflow Orchestration:** Tools across cloud analytics and data pipelines—including Airflow ($157,414), BigQuery ($157,142), GCP ($155,811), and Snowflake ($152,687)—consistently command top-tier compensation, demonstrating that integrating machine learning workflows directly into scalable cloud data infrastructure yields high financial returns.
* **Enterprise BI & Production Deep Learning:** Platforms enabling organizational decision-making (Looker at $158,715 and Qlik at $164,485) combined with foundational deep learning frameworks (PyTorch at $152,603 across 115 postings) strike the optimal balance between healthy market demand and elite six-figure earning power.




# What I Learned
Throughout this adventure, I've turbocharged my SQL toolkit with some serious firepower:

- **🧩 Complex Query Crafting:** Mastered the art of advanced SQL, merging tables like a pro and wielding WITH clauses for ninja-level temp table maneuvers.
- **📊 Data Aggregation:** Got cozy with GROUP BY and turned aggregate functions like COUNT() and AVG() into my data-summarizing sidekicks.
- **💡 Analytical Wizardry:** Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.

# Conclusions
### Insights
 1. Python and SQL Form the Market Foundation:
    * Python (10,390 postings) and SQL (7,488 postings) lead the market by a wide margin, establishing themselves as non-negotiable prerequisite tools across virtually all remote Data Scientist listings.
2.  Compliance and Governance Command Peak Compensation:
     * The highest overall individual skill salary is held by regulatory and privacy governance (GDPR at $217,738), reflecting how critically enterprise organizations value legal compliance and risk mitigation in data and AI systems.
 3.  Production Engineering Out-Earns Pure Analysis:
     * High-performance backend languages (Golang at $208,750, C at $164,865) and deployment/testing frameworks (Selenium at $180,000, DynamoDB at $169,670) significantly outpace standard data wrangling tools in earning power, rewarding practitioners who deploy scalable production systems.
 4. Cloud and Pipeline Orchestration Accelerate Salary Tiers:
    * Enterprise data warehousing and workflow platforms—such as Airflow ($157,414), BigQuery ($157,142), GCP ($155,811), and Snowflake ($152,687)—consistently elevate data science compensation into the upper $150k+ brackets.
 5. Deep Learning Delivers the Highest ROI Balance:
    * Standard deep learning libraries (PyTorch at $152,603 with 115 postings, and TensorFlow at $151,536 with 126 postings) strike the optimal balance between high market demand and competitive six-figure compensation.

### Closing Thoughts
This project enhanced my SQL skills and provided valuable insights into the data scientist job market. The modern data science job market splits into two distinct valuation tiers: foundational tools like Python and SQL grant broad access to job openings, but the highest financial premiums belong to specialists who integrate modeling with high-performance production engineering, cloud infrastructure, and data governance.
