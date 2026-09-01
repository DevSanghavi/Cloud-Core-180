# Day 75 — IAM Lab: Role, Custom Policy, EC2 with Role, STS Verification

## What We Are Studying
We are creating an IAM role with a custom S3 read-only policy, launching a new EC2 instance with that role, and verifying the role from inside the instance using instance metadata and `aws sts get-caller-identity`. This demonstrates instance profiles, least privilege, and role verification—common interview topics.

## Commands Used
| Command | Purpose |
|---------|---------|
| `aws iam create-role` | Create an IAM role for EC2. |
| `aws iam create-policy` | Create a custom S3 read-only managed policy. |
| `aws iam attach-role-policy` | Attach the custom policy to the role. |
| `aws iam create-instance-profile` | Create an instance profile for EC2. |
| `aws iam add-role-to-instance-profile` | Associate the role with the instance profile. |
| `aws ec2 run-instances` | Launch EC2 with the instance profile and IMDSv2. |
| `curl ... 169.254.169.254 ...` | Fetch temporary credentials from instance metadata. |
| `aws sts get-caller-identity` | Verify the assumed role from inside EC2. |

## Architecture
- New IAM role: `Day75-EC2-S3-ReadOnly-Role`
- Custom policy: `Day75-S3-ReadOnly-Bucket` (single bucket, read-only)
- Instance profile: `Day75-EC2-S3-ReadOnly-Profile`
- EC2 instance: `Day75-EC2-S3-Role-Test` (t2.micro, IMDSv2 required)
- S3 bucket: `day75-test-bucket-ACCOUNT_ID`

## Steps Performed
1. Created trust policy for EC2 service.
2. Created IAM role with that trust policy.
3. Created custom S3 read-only policy for a specific bucket.
4. Attached policy to the role.
5. Created instance profile and added the role.
6. Launched EC2 with the instance profile and IMDSv2.
7. Verified role via instance metadata + STS from inside EC2.
8. Tested S3 access (allowed bucket vs denied bucket).

## Troubleshooting Notes
- If `run-instances` fails, ensure subnet and security group exist in the same VPC and region.
- If metadata calls fail, ensure IMDSv2 is enabled and you’re using a token.
- If S3 access is denied, verify the bucket name in the policy matches the actual bucket.

## Lessons Learned
- EC2 uses instance profiles, not roles directly.
- IMDSv2 requires a token for metadata access.
- Custom policies can restrict access to a single bucket and specific actions.
