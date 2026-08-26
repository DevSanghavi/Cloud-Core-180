# Day 68 — Security Groups Deep Dive

## What We Are Studying
We are creating security groups with precise rules to show stateful filtering and least privilege. Security groups are virtual firewalls for EC2 instances.

## How We Did This
1. Loaded VPC ID from Day 66 env file.
2. Created a Web Server SG (HTTP/HTTPS from anywhere, SSH from bastion).
3. Created a Bastion Host SG (SSH from my IP only).
4. Restricted outbound traffic using custom egress rules.
5. Verified rules with describe commands.

## Key Concepts
- **Security Group**: Stateful virtual firewall for EC2 instances.
- **Ingress Rule**: Controls inbound traffic.
- **Egress Rule**: Controls outbound traffic.
- **Least Privilege**: Granting only minimum required access.
- **Stateful**: Return traffic is automatically allowed.

## Commands Used

| Command | Purpose |
|---|---|
| `aws ec2 create-security-group` | Creates a new security group. |
| `aws ec2 authorize-security-group-ingress` | Adds an inbound rule. |
| `aws ec2 authorize-security-group-egress` | Adds an outbound rule. |
| `aws ec2 describe-security-groups` | Shows group configurations. |
| `aws ec2 revoke-security-group-egress` | Removes an outbound rule. |

## Architecture
VPC (10.0.0.0/16) -> Web SG (In: 80/443 from 0.0.0.0/0, 22 from Bastion | Out: 443) + Bastion SG (In: 22 from MY_IP/32 | Out: 22 to Web SG)

## Troubleshooting Notes
- If SSH fails, check your public IP rule.
- Do not use 0.0.0.0/0 for port 22 on the bastion.
- To find public IP run: `curl -s https://amazonaws.com`.

## Lessons Learned
Security groups enforce secure access at the instance level. Separating roles helps restrict management traffic. Stateful filtering removes the need for explicit return rules.
