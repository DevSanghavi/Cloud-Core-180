# Day 109 — AWS ASG Lab
## What We Are Studying
Build a Launch Template and Auto Scaling Group with fixed capacity of 1 t3.micro instance. ASG auto-heals by replacing unhealthy instances. This lab covers core ASG setup without scaling policies.
## Commands Used
| Command | Purpose |
|---------|---------|
| `aws ec2 create-launch-template --launch-template-name <name> --launch-template-data <json>` | Create launch template |
| `aws autoscaling create-auto-scaling-group --auto-scaling-group-name <name> --min-size 1 --max-size 1 --desired-capacity 1` | Create ASG with fixed size |
| `aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names <name>` | View ASG state |
