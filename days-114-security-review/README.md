# Day 114 — Security Review
## What We Are Studying
Security audits identify misconfigurations before attackers exploit them. Common issues: public S3 buckets, unrestricted SSH (0.0.0.0/0), and leaked access keys.
## Commands Used
| Command | Purpose |
|---------|---------|
| `aws s3api get-bucket-policy-status` | Check bucket public access |
| `aws ec2 describe-security-groups` | Audit SG rules |
| `aws iam list-access-keys` | List IAM access keys |
| `aws iam get-account-summary` | Account security overview |
