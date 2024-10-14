WITH skill_demand AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) As demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id=skills_job_dim.skill_id
    WHERE
        job_title_short='Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home=True
    GROUP BY
        skills_dim.skill_id
), avg_salary AS (
    SELECT 
        skills_dim.skill_id,
        ROUND(AVG(salary_year_avg), 0) AS salary_avg
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id=skills_job_dim.skill_id
    WHERE
        job_title_short='Data Analyst' 
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home=True
    GROUP BY
        skills_dim.skill_id
)

SELECT
    skill_demand.skill_id,
    skill_demand.skills,
    demand_count,
    avg_salary
FROM
    skill_demand
INNER JOIN avg_salary ON avg_salary.skill_id=skill_demand.skill_id
ORDER BY demand_count DESC, avg_salary
LIMIT 25