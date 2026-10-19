# Day 124/180 — Project 1, Day 9: EC2 Docker Compose Deployment
## Project: Terraform AWS Infrastructure
This project builds a secure AWS environment with Terraform, including a custom VPC, EC2 application server, private RDS database, security groups, and S3 remote state. GitHub Actions deploys the Docker Compose application to EC2.
## Project Repository
[https://github.com/DevSanghavi/terraform-aws-infra](https://github.com/DevSanghavi/terraform-aws-infra)
All code for this day lives in the project repo above.
## Today
Created a GitHub Actions deployment workflow that temporarily authorizes SSH, copies Compose files to EC2, pulls the GHCR image, and starts Nginx and Flask.
