# Day 88 — Terraform S3 Remote State
## What We Are Studying
We configure an S3 backend for Terraform state.
We verify state migration, S3 versioning, encryption, public-access blocking, and native state locking.
## Commands Used
| Command | Purpose |
|---------|---------|
| `terraform init -migrate-state` | Migrates local state to S3 |
| `terraform state list` | Reads remote state |
| `aws s3api head-object` | Verifies the remote state object |
| `terraform plan` | Checks state consistency |
| `terraform destroy` | Removes the lab resource |
