# Day 160/180 — Phase 7, Day 15: Mock Interview 2

## Interview Instructions

Use the STAR method: **Situation, Task, Action, Result**. Use only real incidents from your projects. Do not invent employers, work experience, metrics, or certifications.

## Behavioral Questions

### 1. Tell me about yourself.

**Situation:** I am a Cloud and DevOps fresher pursuing an MSc in Information Technology after completing BSc IT in Cloud and Application Development with a 9.03 CGPA.  
**Task:** I wanted to build practical, hands-on cloud skills beyond theory.  
**Action:** I completed 159 days of a structured 180-day Cloud/DevOps roadmap and built three end-to-end projects using AWS Free Tier, Terraform, Docker, GitHub Actions, Linux, Nginx, and CloudWatch.  
**Result:** I can now provision AWS infrastructure, build CI/CD pipelines, deploy containers, monitor systems, and troubleshoot real incidents. I am seeking an internship or entry-level Cloud/DevOps role where I can continue learning and contribute to real cloud work.

### 2. Tell me about a challenging technical problem you solved.

**Situation:** During a deployment, my Terraform CD workflow failed because the backend referenced a local AWS profile and a required database password secret was missing.  
**Task:** I needed to identify why the automated runner could not complete the deployment.  
**Action:** I reviewed the workflow logs, backend configuration, secrets, and runner dependencies. I learned that the runner did not have Terraform installed and that the repository needed the required secrets configured.  
**Result:** I understood that CI/CD failures can come from runner environment, credentials, or configuration rather than application code. I now validate runner dependencies, secrets, and backend configuration before deployment.

### 3. Tell me about a time you made a mistake.

**Situation:** While working with multiple repositories under `~/cloud-practice/`, I once ran Git commands from the wrong folder.  
**Task:** I needed to avoid changing the wrong repository or creating confusion in my work.  
**Action:** I slowed down, confirmed the current directory and branch with `git status` and `git branch --show-current`, and created a habit of verifying the repository before running Git commands.  
**Result:** I now treat repository and branch verification as a standard pre-flight check, especially when working across multiple projects.

### 4. Tell me about a time you had to troubleshoot under pressure.

**Situation:** My SSH connection to EC2 timed out after my home IP changed and I no longer had the correct SSH key.  
**Task:** I needed to regain access to the EC2 instance without making unsafe network changes.  
**Action:** I used AWS Systems Manager instead of broad SSH access. When the SSM agent was offline, I identified that the instance role needed to be attached.  
**Result:** I regained a safer access path and learned that access issues can involve security groups, IAM roles, and SSM configuration—not only SSH keys.

### 5. Tell me about a time you improved reliability.

**Situation:** My CloudWatch disk alarm remained in `INSUFFICIENT_DATA`, so I could not rely on it to detect disk issues.  
**Task:** I needed to make the monitoring alarm useful and trustworthy.  
**Action:** I investigated the CloudWatch metric dimensions and found they did not match the actual disk metric. I corrected the dimensions so the alarm could evaluate real data.  
**Result:** The alarm became reliable, and I learned to validate monitoring configuration before treating an alert state as proof of an infrastructure problem.

### 6. Tell me about a time you learned something quickly.

**Situation:** My Node.js container failed because the application required Node 22, but the Docker image used Node 18.  
**Task:** I needed to identify the root cause and deploy a compatible version.  
**Action:** I reviewed the application requirements, Docker image version, and container logs. I learned that runtime compatibility must be validated across the application, Dockerfile, and CI environment.  
**Result:** I now check runtime versions and dependencies early in the deployment process.

### 7. Tell me about a time you had to ask for help.

**Situation:** I encountered several unfamiliar issues, including RDS subnet-group requirements, SSM agent configuration, and CloudWatch metric dimensions.  
**Task:** I needed to solve the issues correctly without damaging my running projects.  
**Action:** I researched official documentation, inspected logs and configurations, and used a structured troubleshooting approach instead of guessing.  
**Result:** I learned that asking precise questions and checking evidence is faster than making unverified changes.

### 8. How do you prioritize when multiple issues occur at once?

**Situation:** During incident response, multiple symptoms can appear, such as a website being down, high resource usage, and deployment failures.  
**Task:** I need to restore service safely while identifying the root cause.  
**Action:** I start with user impact and the cheapest checks: public endpoint, EC2 state, container status, Nginx logs, alarms, and application logs. I isolate the failure layer before changing anything.  
**Result:** This approach prevents blind restarts and helps me identify whether the issue is network, application, database, or infrastructure related.

### 9. How do you handle feedback?

**Situation:** While building my projects, I encountered repeated failures in CI/CD, Docker, Terraform, and monitoring.  
**Task:** I needed to improve rather than repeat the same mistakes.  
**Action:** I documented each real incident, identified the root cause, and added prevention steps to my runbooks and documentation.  
**Result:** I now use failures as learning material and can explain both the incident and the prevention step in interviews.

### 10. Why do you want to work in Cloud/DevOps?

**Situation:** I enjoy building systems that are automated, observable, and reliable.  
**Task:** I wanted to turn that interest into practical skills.  
**Action:** I built projects involving AWS infrastructure, CI/CD, Docker, monitoring, and incident response.  
**Result:** I am motivated to work in Cloud/DevOps because it combines problem-solving, automation, reliability, and continuous learning.

### 11. What are your strengths?

**Situation:** Through my 159-day roadmap, I built and troubleshot real cloud systems.  
**Task:** I needed to develop practical, job-relevant skills.  
**Action:** I practiced Linux, Docker, Terraform, AWS, GitHub Actions, monitoring, and incident response through hands-on projects.  
**Result:** My strengths are structured troubleshooting, documentation, willingness to learn, and the ability to explain technical issues clearly.

### 12. Where do you see yourself in two years?

**Situation:** I am starting my Cloud/DevOps career as a fresher.  
**Task:** I want to build strong foundational experience in a real team.  
**Action:** I plan to continue strengthening AWS, Terraform, CI/CD, containers, monitoring, and incident-response skills while contributing to real projects.  
**Result:** In two years, I want to be a dependable junior Cloud/DevOps engineer who can own deployment tasks, improve reliability, and help troubleshoot production issues.

## Salary Negotiation Prep

### Research a Range

Use free sources to research the role, city, and experience level:

- LinkedIn Jobs: review posted salary ranges where available.
- Glassdoor: review salary insights for similar roles and locations.
- AmbitionBox: review India-specific salary ranges.
- Naukri: review job descriptions and salary information where available.
- Company career pages: review the role’s responsibilities and required skills.

Do not state a salary expectation until you understand the role, location, employment type, and total compensation structure.

### Response to the First Offer

```text
Thank you for the offer. I am excited about the opportunity and the chance to contribute to the team.

Before accepting, could you please share the full compensation structure, including base salary, variable pay if applicable, insurance, leave policy, probation period, and any other benefits?

Based on my hands-on AWS, Terraform, Docker, GitHub Actions, monitoring, and incident-response project work, I was expecting a range of [state your researched range only if you have one]. Could we discuss whether there is flexibility in the offer?
```

### Ask for Time

```text
Thank you for the offer. I appreciate the opportunity and would like to review the complete details carefully.

Could I please have until [specific date] to respond? I want to make a well-informed decision and ensure I can commit fully to the role.
```

### If the Offer Is Below Expectations

```text
Thank you for sharing the offer. I am very interested in the role and the opportunity to learn from the team.

Based on my hands-on project experience with AWS, Terraform, Docker, CI/CD, and monitoring, I was targeting a range of [state your researched range only if you have one]. Is there any flexibility in the base salary or overall compensation package?

I am open to discussing a package that works for both of us.
```

### If You Need to Accept

```text
Thank you for the opportunity. I am happy to accept the offer and look forward to joining the team.

Could you please send the final offer letter with the compensation structure, joining date, and other employment details in writing?
```

## Negotiation Rules

- Never invent salary expectations, experience, or competing offers.
- Research before responding; do not accept or reject immediately under pressure.
- Ask for the complete compensation structure, not only the base salary.
- Be respectful, specific, and brief.
- Ask for time in writing if you need it.
- Do not lie about other offers.
- Focus on the value you can bring: hands-on AWS, Terraform, Docker, CI/CD, monitoring, and troubleshooting skills.
