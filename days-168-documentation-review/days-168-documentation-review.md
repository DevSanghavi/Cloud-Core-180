# Day 168 — Documentation Review: Ensure every repo has install steps, diagrams, and cleanup guides

## Goal

Review the documentation in P1, P2, and P3 and ensure each repository clearly explains installation, architecture, operation, verification, and cleanup.

## Documentation Standard

Every project README should include:

1. Project purpose and key technologies.
2. Architecture diagram or clearly described architecture.
3. Prerequisites and required tools.
4. Step-by-step installation instructions.
5. Configuration requirements without exposing secrets.
6. Deployment or run instructions.
7. Health-check and verification commands.
8. Rollback or recovery guidance where applicable.
9. Monitoring and backup guidance where applicable.
10. Cleanup or teardown guidance that is explicit, safe, and non-destructive by default.

## Repository Review Checklist

| Requirement | P1 | P2 | P3 |
|---|---|---|---|
| Project purpose explained | Yes/No | Yes/No | Yes/No |
| Architecture diagram or description | Yes/No | Yes/No | Yes/No |
| Prerequisites listed | Yes/No | Yes/No | Yes/No |
| Installation steps clear | Yes/No | Yes/No | Yes/No |
| Configuration steps clear | Yes/No | Yes/No | Yes/No |
| Deployment steps clear | Yes/No | Yes/No | Yes/No |
| Health checks documented | Yes/No | Yes/No | Yes/No |
| Rollback or recovery documented | Yes/No | Yes/No | Yes/No |
| Monitoring or backup documented | Yes/No | Yes/No | Yes/No |
| Cleanup guide safe and clear | Yes/No | Yes/No | Yes/No |
| No secrets in README | Yes/No | Yes/No | Yes/No |

## Project 1 — Terraform AWS Infrastructure

Repository: https://github.com/DevSanghavi/terraform-aws-infra

### Required Documentation

- Explain that Terraform provisions the VPC, public and private subnets, route tables, security groups, EC2 instance, and private RDS MySQL database.
- Show the request flow: internet to EC2 port 80, Nginx reverse proxy, Flask application, private RDS MySQL.
- Document prerequisites: AWS CLI, Terraform, Docker, Git, and an AWS account with appropriate permissions.
- Explain how to configure AWS credentials safely without putting them in the repository.
- Document `terraform init`, `terraform plan`, and `terraform apply` as deployment steps.
- Document the health check at `/health`.
- Explain that the EC2 is managed through AWS SSM.
- Include a cleanup guide that clearly warns that `terraform destroy` removes provisioned AWS resources and must be run only after confirming every resource is no longer needed.

### Documentation Improvement Notes

| Area | Current status | Action for Dev |
|---|---|---|
| Architecture diagram | Review README | Add or improve a diagram showing User, Nginx, Flask, and RDS |
| Install steps | Review README | Ensure AWS CLI, Terraform, Docker, and Git setup are complete |
| Cleanup guide | Review README | Explain what `terraform destroy` removes and when to use it |
| Secrets | Review README | Confirm no DB password, AWS key, or account-specific secret appears |

## Project 2 — GitOps CI/CD Pipeline

Repository: https://github.com/DevSanghavi/gitops-cicd-pipeline

### Required Documentation

- Explain the CI/CD flow: code change, GitHub Actions build, image publication to GHCR, deployment, and health verification.
- Explain the production and staging environments.
- Document the release pull-request flow.
- Document the Rollback Production workflow and explain that it redeploys the previous image digest.
- Show the request flow: user to Nginx port 80 for production, and user to EC2 port 8080 for staging.
- Document GitHub Actions secrets required by the workflow without revealing their values.
- Document health checks for production and staging.
- Include a cleanup guide for test containers, images, and workflow artifacts that avoids affecting the running production and staging APIs.

### Documentation Improvement Notes

| Area | Current status | Action for Dev |
|---|---|---|
| CI/CD diagram | Review README | Add or improve a diagram from code push to GHCR to deployment |
| Release flow | Review README | Explain how a release PR reaches production |
| Rollback guide | Review README | Explain how to identify and redeploy the previous digest |
| Cleanup guide | Review README | Separate safe local cleanup from production rollback actions |

## Project 3 — DevOps Monitoring Suite

Repository: https://github.com/DevSanghavi/devops-monitoring-suite

### Required Documentation

- Explain that CloudWatch monitors CPU, memory, and disk utilization.
- Document the alarm thresholds: CPU 70 percent, memory 80 percent, and disk 85 percent.
- Explain that alarms notify SNS, which sends email alerts.
- Document the daily systemd backup timer, backup service, compressed logs, and S3 upload flow.
- Document logrotate and its role in preventing uncontrolled local log growth.
- Explain that the dashboard is application-served at the configured dashboard URL.
- Document how to verify alarms, SNS subscription, timer status, S3 backups, and dashboard availability.
- Include a cleanup guide that separates temporary local files from AWS resources and explicitly warns against deleting active monitoring, backup, or application resources.

### Documentation Improvement Notes

| Area | Current status | Action for Dev |
|---|---|---|
| Monitoring diagram | Review README | Add or improve a diagram from EC2 metrics to CloudWatch, SNS, and email |
| Backup flow | Review README | Show timer, backup script, compressed logs, and S3 objects |
| Verification steps | Review README | Include read-only checks for alarms, timer, S3, and dashboard |
| Cleanup guide | Review README | Clearly distinguish safe local cleanup from AWS resource removal |

## Safe Cleanup Language

Use this wording in every repository cleanup section:

```text
Cleanup removes only resources explicitly created for this project and only after confirming they are no longer needed.

For Terraform-managed AWS resources, review the plan before applying any destructive command. Never run a destroy command against resources that support a running application, active database, monitoring, or backup workflow.

For local test files, remove only files inside the project workspace and never delete credentials, environment files, SSH keys, or shared system files.
```

## Documentation Review Log

| Repository | Install steps | Diagram | Cleanup guide | Secrets safe | Action needed |
|---|---|---|---|---|---|
| P1 | Review | Review | Review | Review | Dev edits README by hand |
| P2 | Review | Review | Review | Review | Dev edits README by hand |
| P3 | Review | Review | Review | Review | Dev edits README by hand |

## Rules Followed

- Only Cloud-Core-180 is changed and pushed in this exercise.
- P1, P2, and P3 repositories are edited by Dev by hand if documentation improvements are needed.
- No AWS create, modify, delete, terminate, or destroy command is used.
- No secrets, credentials, account IDs, or private values are added to documentation.
