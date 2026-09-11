# Day 86 — Terraform AWS Provider
## What We Are Studying
We configure the Terraform AWS provider for us-east-1.
We use the AWS CLI profile through Terraform's credential chain without storing access keys in code.
## Commands Used
| Command | Purpose |
|---------|---------|
| `aws sts get-caller-identity` | Verifies the active AWS identity |
| `terraform init` | Downloads the AWS provider |
| `terraform validate` | Checks configuration |
| `terraform plan` | Previews changes |
| `terraform apply` | Creates infrastructure |
| `terraform destroy` | Removes infrastructure |
