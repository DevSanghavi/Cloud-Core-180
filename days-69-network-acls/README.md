# Day 69 — Network ACLs: Stateless Subnet Filtering

## What We Are Studying
Network ACLs (NACLs) are stateless, subnet-level firewalls in AWS VPCs. They complement Security Groups (stateful, instance-level) by filtering traffic entering/leaving subnets. This is a common interview topic for junior cloud roles.

## How We Did This
1) Created a custom NACL in our existing VPC.
2) Added inbound rules to allow HTTP/HTTPS and a deny rule for a test port (8080).
3) Added matching outbound rules (stateless requirement).
4) Associated the NACL with subnet-A only.
5) Validated behavior using EC2 instances and curl tests.
6) Documented SG vs NACL differences for interviews.

## Commands Used
| Command | Purpose |
|---------|---------|
| `aws ec2 create-network-acl --vpc-id ...` | Creates a custom NACL in the VPC. |
| `aws ec2 create-network-acl-entry --network-acl-id ... --ingress` | Adds an inbound rule (e.g., allow 80). |
| `aws ec2 create-network-acl-entry --network-acl-id ... --egress` | Adds an outbound rule (required for stateless NACLs). |
| `aws ec2 associate-network-acl --network-acl-id ... --subnet-id ...` | Binds the NACL to a specific subnet. |
| `aws ec2 describe-network-acls --network-acl-id ...` | Inspects rules and associations. |

## Architecture
- VPC: vpc-0a8448ba77c0d0d5f (10.0.0.0/16)
- Subnet-A (10.0.1.0/24, us-east-1a): associated with custom NACL
- Subnet-B (10.0.2.0/24, us-east-1b): remains on default NACL
- Web SG: allows 80/443 from 0.0.0.0/0, 22 from bastion-SG
- Bastion SG: allows 22 from 154.84.245.58/32

## Security Layers: SG vs NACL
- Scope: SG = instance ENI; NACL = subnet boundary.
- State: SG = stateful (return traffic auto-allowed); NACL = stateless (need explicit inbound+outbound).
- Rule evaluation: SG = all rules evaluated; NACL = lowest rule number wins.
- Default behavior: Default SG denies all inbound; Default NACL allows all.
- Use case: SG for app-level access control; NACL for coarse subnet policies or emergency blocks.

## Troubleshooting Notes
- If port 80 fails but SG allows it, check NACL inbound+outbound rules.
- NACL deny rules can override SG allows at the subnet level.
- Rule numbers matter: lower number evaluated first in NACLs.

## Lessons Learned
- NACLs are powerful but easy to misconfigure due to statelessness.
- Always pair inbound and outbound rules when using custom NACLs.
- For most apps, SGs are sufficient; NACLs add a second layer when needed.
