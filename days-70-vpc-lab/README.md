# Day 70 — VPC Lab: Public VPC with 2 Subnets (AWS CLI Only)

## What We Are Studying
We build a minimal public VPC from scratch using AWS CLI: VPC (10.0.0.0/16), two public subnets across AZs, an Internet Gateway, a custom route table with 0.0.0.0/0→IGW, and subnet associations. This pattern is foundational for almost every AWS architecture and common in interviews.

## How We Did This
1) Created a VPC with a /16 CIDR.
2) Created two public subnets (10.0.1.0/24 in us-east-1a, 10.0.2.0/24 in us-east-1b).
3) Created and attached an Internet Gateway to the VPC.
4) Created a custom route table and added a default route (0.0.0.0/0) to the IGW.
5) Associated both subnets with the public route table.
6) Enabled auto-assign public IPv4 on both subnets for easy testing.

## Commands Used
| Command | Purpose |
|---------|---------|
| `aws ec2 create-vpc --cidr-block 10.0.0.0/16` | Creates the VPC network boundary. |
| `aws ec2 create-subnet --vpc-id ... --cidr-block 10.0.1.0/24 --availability-zone us-east-1a` | Creates subnet-A in AZ a. |
| `aws ec2 create-subnet --vpc-id ... --cidr-block 10.0.2.0/24 --availability-zone us-east-1b` | Creates subnet-B in AZ b. |
| `aws ec2 create-internet-gateway` + `attach-internet-gateway` | Enables internet access for the VPC. |
| `aws ec2 create-route-table --vpc-id ...` + `create-route ... 0.0.0.0/0 --gateway-id ...` | Makes routes public via IGW. |
| `aws ec2 associate-route-table --route-table-id ... --subnet-id ...` | Binds public routes to subnets. |
| `aws ec2 modify-subnet-attribute --subnet-id ... --map-public-ip-on-launch` | Auto-assigns public IPs to new instances. |

## Architecture
- VPC: 10.0.0.0/16
- Subnet-A: 10.0.1.0/24, us-east-1a (public)
- Subnet-B: 10.0.2.0/24, us-east-1b (public)
- IGW: attached to VPC
- Route Table: 0.0.0.0/0 → IGW, associated to both subnets
- Subnet attribute: map-public-ip-on-launch = true

## Troubleshooting Notes
- If instances can't reach the internet, verify: IGW attached, route 0.0.0.0/0 exists, subnet associated, and SG allows egress.
- Public subnets require both IGW route and proper SG rules; NACLs can also block if custom.
- Use `describe-vpcs`, `describe-subnets`, `describe-route-tables`, and `describe-internet-gateways` to validate.

## Lessons Learned
- Public = subnet route to IGW + IGW attached + (optionally) auto-assign public IP.
- Multi-AZ subnets improve availability for public services.
- CLI-only builds reinforce idempotent, automatable networking patterns.
