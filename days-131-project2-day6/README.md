# Day 131/180 — Project 2, Day 6: Database Migrations
## Project: GitOps CI/CD Pipeline
This project builds a GitHub Actions pipeline using Docker and GHCR.
Staging uses port 8080 on the existing Project 1 EC2.
Production uses port 80 through Nginx on the same instance.
Project 1 infrastructure remains running.
## Project Repository
https://github.com/DevSanghavi/gitops-cicd-pipeline
All code for this day lives in the project repo above.
## Today
Add versioned SQLite migrations and a migration service that must complete successfully before each environment's API starts.
No Project 1 RDS, Terraform, or AWS infrastructure changes.
