# Day 74 — IAM Best Practices: MFA, Password Policy, Key Rotation, No Root Daily

## What We Are Studying
We are implementing core IAM security best practices: strong password policy, MFA enforcement for users, access key rotation, and ensuring root is not used for daily tasks. These are essential for any junior Cloud/DevOps role and commonly asked in interviews.

## Commands Used
| Command | Purpose |
|---------|---------|
| `aws iam update-account-password-policy` | Set strong password rules for all IAM users. |
| `aws iam create-policy` | Create a managed policy that enforces MFA. |
| `aws iam attach-user-policy` | Attach MFA policy to an IAM user. |
| `aws iam create-access-key` | Create new access keys for rotation. |
| `aws iam update-access-key` | Mark old access keys as inactive. |
| `aws iam delete-access-key` | Delete old access keys after rotation. |
| `aws iam get-account-summary` | Check account-level IAM settings (e.g., root MFA). |

## Architecture
- One AWS account with:
  - Strong account-wide password policy.
  - MFA-enforced policy attached to admin users.
  - Access key rotation process for programmatic users.
  - Root user protected (MFA on, no daily usage, no access keys).

## Steps Performed
1. Set account password policy (14+ chars, symbols/numbers/upper/lower, 90-day expiry).
2. Created `Day74-MFA-Enforced` managed policy.
3. Attached MFA policy to `cloudmentor-admin` user.
4. Demonstrated access key creation, listing, deactivation, and deletion.
5. Verified root user security posture (MFA, no keys).

## Troubleshooting Notes
- If MFA policy blocks you before enabling MFA, use the console to enable MFA first.
- If access key commands fail, ensure you’re using a user with `iam:*` permissions.
- Root access keys should never exist; delete them immediately if found.

## Lessons Learned
- MFA enforcement via policy is more scalable than per-user settings.
- Password policies apply to all IAM users, not root.
- Access key rotation is a simple 4-step process: create, test, disable, delete.
- Root should only be used for account-level tasks (e.g., closing account, support plans).
