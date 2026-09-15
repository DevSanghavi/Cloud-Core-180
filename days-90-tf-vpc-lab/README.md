# Day 90 — Terraform VPC Lab
## What We Are Studying
Build a production-style VPC with public/private subnets, internet gateway, NAT gateway, and route tables using Terraform.
## Commands Used
| Command | Purpose |
|---------|---------|
| `terraform plan -var-file=dev.tfvars` | Preview VPC infrastructure |
| `terraform output -json` | Show network resource IDs |
| `terraform state list` | Audit created resources |
