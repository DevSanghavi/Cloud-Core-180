# Day 132/180 — Project 2, Day 7: Production Rollback
## Project: GitOps CI/CD Pipeline
This project builds a GitHub Actions pipeline using Docker and GHCR.
Staging uses port 8080 on the existing Project 1 EC2.
Production uses port 80 through Nginx on the same instance.
Project 1 infrastructure remains running.
## Project Repository
https://github.com/DevSanghavi/gitops-cicd-pipeline
All code for this day lives in the project repo above.
## Today
Promote the current staging digest, deploy a new production digest, roll back to the previous good digest, and restore Git desired state.
No AWS infrastructure is created or destroyed.
