# Day 72 — IAM Policy Documents: JSON Structure

## What We Are Studying
IAM policies are JSON documents that define permissions in AWS. Every policy has a Version, an Id (optional), and one or more Statement blocks. Each statement contains Effect (Allow/Deny), Action (what API calls), Resource (which ARNs), and optional Condition (when the rule applies). This is the foundation of all AWS access control and is heavily tested in Cloud/DevOps interviews.

## How We Did This
1. Created sample IAM policies using AWS CLI with JSON heredocs.
2. Explored each element: Version, Statement, Effect, Action, Resource, Condition.
3. Practiced least-privilege patterns: specific actions, specific resources, and conditions like source IP and MFA.
4. Validated policies with aws iam simulate-custom-policy and by attaching to users/roles.

## Commands Used
| Command | Purpose |
|---------|---------|
| aws iam create-policy | Creates a managed policy from a JSON file. |
| aws iam create-policy-version | Creates a new version of an existing policy. |
| aws iam simulate-custom-policy | Tests a policy JSON against sample actions/resources. |
| aws iam attach-user-policy | Attaches a managed policy to a user. |
| aws iam attach-role-policy | Attaches a managed policy to a role. |
| jq | Parses and formats JSON policy documents. |

## Key Concepts
- Version: Always "2012-10-17" for IAM policies.
- Statement: Array of permission blocks.
- Effect: "Allow" or "Deny". Explicit deny always wins.
- Action: List of API actions (e.g., "s3:GetObject", "ec2:Describe*").
- Resource: ARN or list of ARNs the actions apply to.
- Condition: Optional; further restricts when the statement applies (e.g., source IP, MFA, time).

## Troubleshooting Notes
- Missing "Resource" on actions that require it causes "MalformedPolicyDocument" errors.
- Wildcards (*) in Action or Resource are powerful but violate least privilege.
- Conditions must match the action's supported condition keys (check AWS docs).
- Use aws iam simulate-custom-policy to test policies before attaching.

## Lessons Learned
- Always start with minimal permissions and expand only as needed.
- Use conditions to add defense-in-depth (e.g., restrict to home IP, require MFA).
- Policy evaluation follows: explicit deny > explicit allow > implicit deny.
