# Day 175 — Follow-ups: Check statuses, send polite reminder messages

## Goal

Review all applications from Days 172 and 174, check their current status, and send polite follow-up messages only for applications that remain active and have passed a reasonable waiting period.

## Follow-Up Rules

- Check only real applications recorded in the tracker.
- Do not send a follow-up for a rejected or closed application.
- Do not send more than one follow-up per application.
- Wait at least 7 days after applying before sending a follow-up, unless the job posting gives a different timeline.
- Send follow-ups through the same professional channel used for the application, such as email or LinkedIn.
- Keep every message short, polite, and specific.
- Do not demand a response or claim experience, employers, metrics, salaries, or company names that are not real.
- Do not include `.env`, credentials, account IDs, or private keys.

## Follow-Up Decision Table

| Application status | Follow-up action |
|---|---|
| Applied and less than 7 days old | Wait; do not follow up yet |
| Applied and 7 or more days old | Send one polite follow-up |
| Application withdrawn or closed | Do not follow up |
| Rejected | Do not follow up |
| Interview scheduled | Prepare; do not send a status reminder |
| Offer received | Respond professionally and promptly |
| No response after one follow-up | Do not send another follow-up |

## Follow-Up Message Template

```text
Subject: Follow-up on [ROLE TITLE] application

Dear [RECRUITER NAME OR HIRING TEAM],

I hope you are doing well. I applied for the [ROLE TITLE] position at [COMPANY NAME] on [APPLICATION DATE]. I wanted to politely follow up to ask whether there is any update on the status of my application.

I remain interested in the opportunity and would be happy to provide any additional information needed. My hands-on projects include Terraform-based AWS infrastructure, GitOps-style CI/CD deployments with rollback automation, and CloudWatch monitoring with S3 log backups.

Repository links:
- Terraform AWS Infrastructure: [https://github.com/DevSanghavi/terraform-aws-infra](https://github.com/DevSanghavi/terraform-aws-infra)
- GitOps CI/CD Pipeline: [https://github.com/DevSanghavi/gitops-cicd-pipeline](https://github.com/DevSanghavi/gitops-cicd-pipeline)
- DevOps Monitoring Suite: [https://github.com/DevSanghavi/devops-monitoring-suite](https://github.com/DevSanghavi/devops-monitoring-suite)

Thank you for your time and consideration.

Sincerely,  
Dev Sanghavi
```

## Follow-Up Tracker

| # | Company | Role | Application date | Days since application | Current status | Follow-up sent | Follow-up date | Response received | Next action |
|---|---|---|---|---:|---|---|---|---|---|
| 1 |  |  |  |  |  | Yes/No |  | Yes/No |  |
| 2 |  |  |  |  |  | Yes/No |  | Yes/No |  |
| 3 |  |  |  |  |  | Yes/No |  | Yes/No |  |
| 4 |  |  |  |  |  | Yes/No |  | Yes/No |  |
| 5 |  |  |  |  |  | Yes/No |  | Yes/No |  |
| 6 |  |  |  |  |  | Yes/No |  | Yes/No |  |
| 7 |  |  |  |  |  | Yes/No |  | Yes/No |  |
| 8 |  |  |  |  |  | Yes/No |  | Yes/No |  |
| 9 |  |  |  |  |  | Yes/No |  | Yes/No |  |
| 10 |  |  |  |  |  | Yes/No |  | Yes/No |  |

## Status Review Checklist

For every application, confirm:

1. The company and role are real.
2. The application date is recorded.
3. The current status is accurate.
4. The application is still open.
5. At least 7 days have passed since applying.
6. No previous follow-up has already been sent.
7. The follow-up message is personalized with the company and role.
8. The follow-up is sent through the correct channel.
9. The follow-up date and response status are recorded.
10. No repeated follow-up is sent if there is no response.

## LinkedIn Follow-Up Template

Use this only after a recruiter or engineer accepts a connection request and the application is at least 7 days old:

```text
Thank you for connecting, [FIRST NAME]. I applied for the [ROLE TITLE] role at [COMPANY NAME] on [APPLICATION DATE] and wanted to politely ask whether there is any update on the application status. I remain interested in the opportunity and would be happy to share any additional information. Thank you for your time.
```

## Rules

- Dev sends all follow-up messages by hand.
- Use only real companies, roles, recruiters, and application statuses.
- Do not invent experience, employers, metrics, salaries, or company names.
- Do not include `.env`, credentials, account IDs, or private keys in any message.
