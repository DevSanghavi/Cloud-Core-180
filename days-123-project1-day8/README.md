# Day 123/180 — Project 1, Day 8: Terraform CD with GitHub Actions
## Project: Terraform AWS Infrastructure
This project builds a secure AWS environment with Terraform, including a custom VPC, EC2 application server, private RDS database, security groups, and S3 remote state. GitHub Actions automates infrastructure deployment after code changes.
## Project Repository
[https://github.com/DevSanghavi/terraform-aws-infra](https://github.com/DevSanghavi/terraform-aws-infra)
All code for this day lives in the project repo above.
## Today
Created a dedicated AWS deployment user, stored its credentials as GitHub secrets, and added a Terraform CD workflow that validates, plans, and applies infrastructure changes.
