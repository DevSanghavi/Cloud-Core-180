# Day 166 — Architecture Defense: Explain all 3 projects out loud in under 3 minutes each

## Goal

Deliver a clear spoken explanation of each project in under three minutes, covering purpose, architecture, workflow, verification, challenges, and improvements.

## Project 1 — Terraform AWS Infrastructure

Repository: https://github.com/DevSanghavi/terraform-aws-infra

### Spoken Script

Project 1 provisions and runs a Flask application on AWS using Terraform, Docker, and Nginx.

Terraform creates the core networking and compute resources: a VPC, public and private subnets across two Availability Zones, internet gateway, route tables, security groups, an EC2 t3.micro Ubuntu instance, and a private RDS MySQL database. The EC2 instance runs Docker containers, while the RDS database remains in the private network.

The Flask application runs in the `terraform-aws-infra-flask` container. Nginx runs in the `terraform-aws-infra-nginx` container and listens on host port 80. It acts as a reverse proxy and forwards incoming web traffic to the application. The Nginx configuration is supplied through a read-only single-file bind mount from the host.

I manage the EC2 instance through AWS Systems Manager rather than relying on SSH from a changing home IP. The application health endpoint is available at `/health` and returns HTTP 200 with the application status, environment, database status, and current image digest.

The main challenge was understanding that RDS requires a DB subnet group with subnets in at least two Availability Zones. I also learned to keep secrets out of Terraform state and CI workflows, and to verify infrastructure using read-only commands such as `terraform state list`.

If I improved this project, I would add automated infrastructure tests, remote state locking documentation, and more detailed cost controls.

### Likely Follow-Up Questions

1. Why use Nginx in front of Flask?
2. Why is RDS placed in private subnets?
3. What does Terraform state represent?
4. How would you safely change the EC2 instance type?
5. How do you prevent secrets from being exposed in Terraform or GitHub Actions?

## Project 2 — GitOps CI/CD Pipeline

Repository: https://github.com/DevSanghavi/gitops-cicd-pipeline

### Spoken Script

Project 2 is a GitOps-style CI/CD pipeline that builds, deploys, and operates separate production and staging environments for a Node.js API.

When code changes are merged through the release process, GitHub Actions builds a container image and publishes it to GitHub Container Registry. The deployment workflow then updates the running containers using the published image digest.

The production API runs as `project2-production-api`, while staging runs as `project2-staging-api` on host port 8080. Both containers expose health endpoints. The production endpoint is reachable through the P1 Nginx reverse proxy on port 80, and staging is accessed directly on port 8080.

The project includes a release pull-request flow, which gives me a controlled review point before production deployment. It also includes a Rollback Production workflow that can redeploy the previous image digest if a new release causes a problem.

I verify the pipeline by checking GitHub Actions runs, container health through SSM, and the `/health` endpoint for both environments. The health response includes the environment name, database status, and image digest, which makes it easy to confirm which version is running.

A key lesson was ensuring the CI runner had all required secrets and that the Dockerfile did not copy host-generated `node_modules`. I also learned that `npm ci` requires a lockfile and that dependency versions must match the Node base image.

If I improved this project, I would add automated integration tests before deployment, progressive delivery, and more detailed deployment approvals.

### Likely Follow-Up Questions

1. What is GitOps, and how does this project follow it?
2. Why deploy to staging before production?
3. How does the rollback workflow identify the previous version?
4. What is the difference between an image tag and an image digest?
5. How would you prevent a bad deployment from reaching production?

## Project 3 — DevOps Monitoring Suite

Repository: https://github.com/DevSanghavi/devops-monitoring-suite

### Spoken Script

Project 3 adds operational monitoring, alerting, and backup automation for the running P1 and P2 environment.

CloudWatch monitors three important host metrics: CPU utilization, memory utilization, and disk utilization. The alarms trigger at 70 percent CPU, 80 percent memory, and 85 percent disk usage. When an alarm enters an alarm state, it publishes a notification to an SNS topic, which sends an email alert.

The project also automates daily log backups. A systemd timer runs a backup service once per day. The service collects container logs, compresses them, and uploads the archives to an S3 bucket. The backup timer is named `devops-monitoring-backup.timer`, and recent S3 objects confirm that backups contain non-zero compressed log data.

I use logrotate to control local log growth so the EC2 root disk does not fill up. The project also includes an application-served dashboard endpoint that returns HTTP 200 and provides operational visibility.

When investigating disk usage, I first run read-only checks such as `df -h` and `du` to identify what is consuming space. I then rotate or compress logs; I do not delete active application data or project resources first.

A key lesson was matching CloudWatch alarm dimensions exactly to the metric dimensions. Incorrect dimensions can leave an alarm in `INSUFFICIENT_DATA`. I also learned the difference between the Docker `json-file` driver, which stores logs locally, and `awslogs`, which sends logs to CloudWatch Logs.

If I improved this project, I would add retention policies for S3 backups, more dashboard panels, synthetic endpoint checks, and automated restore testing.

### Likely Follow-Up Questions

1. Which metrics do the CloudWatch alarms monitor?
2. How does an alarm reach your email?
3. How does the daily backup work?
4. How would you respond to a disk-full alert?
5. What is the difference between `json-file` and `awslogs`?

## Practice Method

1. Read each script once.
2. Explain each project aloud without reading for the second attempt.
3. Time each explanation; keep it under three minutes.
4. Answer the follow-up questions aloud.
5. Record the strongest and weakest parts of each explanation.

## Defense Checklist

| Project | Purpose clear | Architecture clear | Workflow clear | Verification clear | Challenges clear | Under 3 minutes |
|---|---|---|---|---|---|---|
| P1 | Yes/No | Yes/No | Yes/No | Yes/No | Yes/No | Yes/No |
| P2 | Yes/No | Yes/No | Yes/No | Yes/No | Yes/No | Yes/No |
| P3 | Yes/No | Yes/No | Yes/No | Yes/No | Yes/No | Yes/No |

## Rules Followed

- No AWS create, modify, delete, terminate, or destroy commands were used.
- P1, P2, and P3 repositories and running resources remain untouched.
- All explanations use only completed project work and verified facts.
- No experience, employers, metrics, salaries, or company names were invented.
