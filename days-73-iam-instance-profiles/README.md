# Day 73 — IAM Instance Profiles: EC2 Access Without Secret Keys

## What We Are Studying
IAM instance profiles let EC2 instances assume an IAM role and receive temporary security credentials automatically via the Instance Metadata Service (IMDS). This means applications running on the instance can call AWS services (S3, DynamoDB, etc.) without any hardcoded access keys or secret keys on disk. This is a foundational security pattern for Cloud/DevOps and is frequently asked in interviews.

## How We Did This
1. Created an IAM role with a trust policy for EC2 (ec2.amazonaws.com).
2. Attached a permissions policy (S3 read-only) to the role.
3. Created an instance profile and added the role to it.
4. Launched an EC2 instance with the instance profile attached.
5. Validated access by running aws s3 ls from the instance using IMDSv2 tokens.

## Commands Used
| Command | Purpose |
|---------|---------|
| aws iam create-role | Creates an IAM role with a trust policy. |
| aws iam create-policy | Creates a managed IAM policy. |
| aws iam attach-role-policy | Attaches a managed policy to a role. |
| aws iam create-instance-profile | Creates an instance profile container. |
| aws iam add-role-to-instance-profile | Adds a role to an instance profile. |
| aws ec2 run-instances | Launches EC2 with an instance profile. |
| curl (IMDSv2) | Obtains temporary credentials from instance metadata. |
| aws s3 ls | Validates S3 access from the EC2 instance. |

## Key Concepts
- Trust Policy: Defines which principal (e.g., ec2.amazonaws.com) can assume the role.
- Instance Profile: A container that holds exactly one IAM role for EC2.
- IMDSv2: Session-based metadata service that requires a token; more secure than IMDSv1.
- Temporary Credentials: Short-lived keys (typically 6 hours) automatically rotated by AWS.

## Troubleshooting Notes
- If aws s3 ls fails with "Access Denied", check the role's attached policies and trust relationship.
- Ensure IMDSv2 is enforced on the instance (HttpTokens = required) for security.
- Instance profiles can contain only one role; to change permissions, modify the role, not the profile.

## Lessons Learned
- Never store long-term access keys on EC2; always use instance profiles.
- IMDSv2 prevents SSRF attacks that could steal credentials from IMDSv1.
- Instance profiles are the standard way to give EC2 access to other AWS services.
