# Day 87 — Terraform EC2 Resource
## What We Are Studying
We define an Amazon Linux 2023 t3.micro EC2 instance in Terraform HCL.
We create a Day 87 SSH key pair and security group, then connect to the instance.
## Commands Used
| Command | Purpose |
|---------|---------|
| `terraform init` | Initializes Terraform |
| `terraform validate` | Validates HCL |
| `terraform plan` | Previews infrastructure |
| `terraform apply` | Creates infrastructure |
| `aws ec2 describe-instances` | Verifies EC2 state |
| `ssh` | Tests remote access |
| `terraform destroy` | Removes infrastructure |
