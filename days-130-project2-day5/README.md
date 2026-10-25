# Day 130/180 — Project 2, Day 5: Production Promotion
## Project: GitOps CI/CD Pipeline
This project builds a GitHub Actions pipeline using Docker and GHCR.
Staging uses port 8080 on the existing Project 1 EC2.
Production uses port 80 through Nginx on the same instance.
Project 1 infrastructure remains running.
## Project Repository
https://github.com/DevSanghavi/gitops-cicd-pipeline
All code for this day lives in the project repo above.
## Today
Promote the verified staging image digest through a release PR into main, deploy it behind existing Nginx, and verify public port 80 health.
No new AWS infrastructure is created.
