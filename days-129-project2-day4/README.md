# Day 129/180 — Project 2, Day 4: Staging CD Pipeline
## Project: GitOps CI/CD Pipeline
This project builds a GitHub Actions pipeline using Docker and GHCR.
Staging uses port 8080 on the existing Project 1 EC2.
Production uses port 80 through Nginx on the same instance.
Project 1 infrastructure remains running.
## Project Repository
https://github.com/DevSanghavi/gitops-cicd-pipeline
All code for this day lives in the project repo above.
## Today
Deploy every merge into develop to staging using one GHCR digest, temporary SSH access, Docker Compose, and a public health check.
No new AWS infrastructure is created.
