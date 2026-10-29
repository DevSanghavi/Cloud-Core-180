# Day 134/180 — Project 2, Day 9: SNS Failure Alerts
## Project: GitOps CI/CD Pipeline
This project builds a GitHub Actions pipeline using Docker and GHCR.
Staging uses port 8080 on the existing Project 1 EC2.
Production uses port 80 through Nginx on the same instance.
Project 1 infrastructure remains running.
## Project Repository
https://github.com/DevSanghavi/gitops-cicd-pipeline
All code for this day lives in the project repo above.
## Today
Create an SNS email subscription and notify on CI, staging, or production workflow failure.
No EC2, RDS, Terraform, or Project 1 infrastructure changes.
