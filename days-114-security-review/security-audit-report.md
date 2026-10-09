# Day 114 Security Audit Report
## Date: 2026-10-09
## S3 Buckets
- Checked: All buckets for public policy
- Risk: Public buckets expose data
## Security Groups
- Checked: SSH rules with 0.0.0.0/0
- Risk: Unrestricted SSH allows brute force
## IAM Access Keys
- Checked: Active keys and age
- Risk: Old keys may be compromised
## Git History
- Checked: AKIA and secret keys in commits
- Risk: Leaked keys grant account access
