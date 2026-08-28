# Day 71 — IAM Roles vs Users: Safer Credentials for Applications

## What We Are Studying
IAM Roles provide temporary, auto-rotated credentials via STS and are the recommended way for AWS workloads to access AWS services. IAM Users with long-term access keys are riskier for applications because keys can leak and must be manually rotated. This pattern is critical for security and common in interviews.

## How We Did This
1) Created an IAM role for EC2 with a trust policy for ec2.amazonaws.com.
2) Attached the managed policy AmazonS3ReadOnlyAccess to the role.
3) Created an instance profile and attached the role.
4) Launched an EC2 in a public subnet with the instance profile.
5) Validated from the EC2 that AWS CLI works without any configured keys.
6) Documented why roles are safer than long-term user keys for apps.

## Commands Used
| Command | Purpose |
|---------|---------|
| `aws iam create-role --role-name ... --assume-role-policy-document file://trust-policy.json` | Creates a role that EC2 can assume. |
| `aws iam attach-role-policy --role-name ... --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess` | Grants S3 read-only permissions to the role. |
| `aws iam create-instance-profile --instance-profile-name ...` + `add-role-to-instance-profile` | Wraps the role for EC2 attachment. |
| `aws ec2 run-instances --iam-instance-profile Name=...` | Launches EC2 with the role attached. |
| `curl http://169.254.169.254/latest/meta-data/iam/security-credentials/` (IMDS) | Shows the role name on the instance. |
| `aws s3 ls` (from EC2, no keys configured) | Validates keyless AWS access via role. |

## Architecture
- VPC: vpc-03c0b86d2986d03ea (Day 70 public VPC)
- Subnet: subnet-004e2bb77d17ae45c (public, us-east-1a)
- Security Group: allow SSH from your IP (bastion-style)
- IAM Role: Day71-EC2-S3ReadOnly (trust: ec2.amazonaws.com)
- Managed Policy: AmazonS3ReadOnlyAccess attached to role
- Instance Profile: Day71-EC2-S3ReadOnly-Profile attached to EC2

## Security Notes
- Roles issue temporary credentials via STS; they auto-rotate and reduce key leakage risk.
- IAM Users + long-term keys are for humans; avoid embedding keys in apps or on EC2.
- Use IMDSv2 on EC2 and least-privilege policies for roles.

## Troubleshooting Notes
- If `aws s3 ls` fails on the EC2, check: role attached, instance profile associated, SG allows outbound, and no conflicting env vars.
- Use `aws sts get-caller-identity` on the EC2 to confirm the role ARN is being used.

## Lessons Learned
- Roles are the default pattern for workloads; they remove the need for static keys.
- Instance profiles are the mechanism that delivers role credentials to EC2.
- For interviews: “Apps should use roles; users with keys are for humans.”
