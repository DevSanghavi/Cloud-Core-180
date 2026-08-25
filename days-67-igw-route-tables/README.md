# Day 67 — Internet Gateway & Route Tables: Public Subnet Routing

## What We Are Studying
We are attaching an Internet Gateway (IGW) to our VPC and creating a custom route table with a default route (0.0.0.0/0) to the IGW. Then we associate both public subnets with this route table. This makes the subnets truly "public" — resources in them can reach the internet.

## How We Did This
1. Loaded VPC and subnet IDs from the central `.env` file in the project root directory.
2. Created an Internet Gateway and attached it to the VPC.
3. Created a custom route table and added a default route (0.0.0.0/0) to the IGW.
4. Associated both public subnets with the route table.
5. Verified the route table associations and routes.

## Key Concepts
- **Internet Gateway (IGW)**: A horizontally scaled, redundant gateway that allows resources in your VPC to access the internet. It is the "door" between your VPC and the internet.
- **Route Table**: A set of rules (routes) that determine where network traffic is directed. Every subnet must be associated with a route table.
- **Default Route (0.0.0.0/0)**: A catch-all route that sends traffic destined for the internet to the IGW.
- **Public Subnet**: A subnet whose route table has a default route to an IGW.

## Commands Used

| Command | Purpose |
|---------|---------|
| `aws ec2 create-internet-gateway` | Creates a new IGW. |
| `aws ec2 attach-internet-gateway --vpc-id` | Attaches the IGW to your VPC. |
| `aws ec2 create-route-table --vpc-id` | Creates a route table in your VPC. |
| `aws ec2 create-route --route-table-id --destination-cidr-block 0.0.0.0/0 --gateway-id` | Adds a default route to the IGW. |
| `aws ec2 associate-route-table --subnet-id` | Associates a subnet with the route table. |
| `aws ec2 describe-route-tables --filters` | Verifies route table configuration. |

## Architecture / Diagram
```text
Region: us-east-1
└── VPC: cloud-mentor-vpc (10.0.0.0/16)
    ├── Internet Gateway: cloud-mentor-igw
    └── Route Table: cloud-mentor-public-rt
        ├── Route: 0.0.0.0/0 → igw-xxx (Internet Gateway)
        ├── Subnet Association: subnet-08955adde69cd1bdc (10.0.1.0/24, us-east-1a)
        └── Subnet Association: subnet-01e56377572df375f (10.0.2.0/24, us-east-1b)
```

## Troubleshooting Notes
- If `attach-internet-gateway` fails with "Gateway not found", wait 5 seconds after creating the IGW — AWS propagates resources asynchronously.
- If route association fails, ensure the subnet is not already associated with a custom route table (a subnet can only be associated with one route table at a time).
- Use `aws ec2 describe-route-tables --filters "Name=vpc-id,Values=vpc-xxx"` to see all route tables in your VPC.

## Lessons Learned
An Internet Gateway alone does not make a subnet public. You must also add a default route (0.0.0.0/0) to the IGW in the subnet's route table. This is a common interview question and a critical concept for designing public-facing architectures.
