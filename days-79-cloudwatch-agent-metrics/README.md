# Day 79 — CloudWatch Agent for Memory and Disk

## What We Are Studying
The CloudWatch Agent collects OS-level metrics like memory and disk usage and publishes them as custom CloudWatch metrics.
These metrics enable alarms and dashboards for resources that AWS does not monitor by default.

## Commands Used
| Command | Purpose |
|---------|---------|
| `aws iam attach-role-policy` | Attaches managed policy to role |
| `aws ec2 associate-iam-instance-profile` | Associates IAM profile to EC2 |
| `aws cloudwatch list-metrics` | Lists custom metrics |
| `aws cloudwatch get-metric-statistics` | Retrieves metric data points |
