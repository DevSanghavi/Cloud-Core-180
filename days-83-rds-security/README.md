# Day 83 — RDS Security
## What We Are Studying
Secure RDS with private subnets, SG rules (app-only access), and KMS encryption at rest. No public access, no 0.0.0.0/0.
## Commands Used
| Command | Purpose |
|---------|---------|
| `aws rds create-db-subnet-group` | Private DB network |
| `aws ec2 authorize-security-group-ingress --source-group` | SG-to-SG access |
| `aws rds create-db-instance --storage-encrypted` | Encrypt data at rest |
