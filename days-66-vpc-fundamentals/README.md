# Day 66 — AWS VPC Fundamentals: Custom VPC and Public Subnets

## What We Are Studying
We are learning to create a custom VPC (Virtual Private Cloud) in AWS, assign it a CIDR block, and build public subnets inside it. This is the foundation for all AWS networking — every EC2, RDS, and Lambda runs inside a VPC.

## How We Did This
1. Used AWS CLI to create a VPC with a /16 CIDR block (10.0.0.0/16).
2. Created two public subnets in different Availability Zones (us-east-1a, us-east-1b).
3. Verified the VPC and subnets using describe commands.
4. Documented the architecture and commands in this README.

## Key Concepts
- **VPC**: Your private network room inside AWS. You control IP ranges, subnets, route tables, and gateways.
- **CIDR Block**: The IP address range for your VPC (e.g., 10.0.0.0/16 gives 65,536 IPs).
- **Subnet**: A slice of your VPC's IP range in a specific Availability Zone. Public subnets have a route to the internet.
- **Availability Zone (AZ)**: A physically separate data center within a region (e.g., us-east-1a, us-east-1b).

## Commands Used

| Command | Purpose |
|---------|---------|
| `aws ec2 create-vpc --cidr-block 10.0.0.0/16` | Creates a VPC with 65,536 private IPs. |
| `aws ec2 create-subnet --vpc-id vpc-xxx --cidr-block 10.0.1.0/24 --availability-zone us-east-1a` | Creates a public subnet with 256 IPs in us-east-1a. |
| `aws ec2 describe-vpcs --vpc-ids vpc-xxx` | Shows VPC details (CIDR, state, tags). |
| `aws ec2 describe-subnets --filters "Name=vpc-id,Values=vpc-xxx"` | Lists all subnets in the VPC. |

## Architecture / Diagram
```text
Region: us-east-1
└── VPC: cloud-mentor-vpc (10.0.0.0/16)
    ├── Public Subnet A: 10.0.1.0/24 (us-east-1a)
    └── Public Subnet B: 10.0.2.0/24 (us-east-1b)
```

## Troubleshooting Notes
- If you get "VpcId not found", wait 5 seconds after creation — AWS propagates resources asynchronously.
- If subnet creation fails, check that the subnet CIDR (e.g., 10.0.1.0/24) is within the VPC CIDR (10.0.0.0/16).
- Use `aws ec2 describe-availability-zones` to list valid AZs in your region.

## Lessons Learned
Creating a VPC is the first step in building any AWS network. Subnets let you segment resources by AZ for high availability. Public subnets will later connect to the internet via an Internet Gateway.
