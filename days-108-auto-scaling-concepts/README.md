# Day 108 — Auto Scaling Concepts
## What We Are Studying
Auto Scaling Groups (ASG) automatically adjust EC2 capacity based on demand. Launch Templates define instance configuration. Desired capacity sets target instance count. Scale-out events add instances during high load.
## Commands Used
| Command | Purpose |
|---------|---------|
| `aws autoscaling create-auto-scaling-group --auto-scaling-group-name <name>` | Create ASG |
| `aws autoscaling update-auto-scaling-group --desired-capacity <n>` | Set desired capacity |
| `aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names <name>` | View ASG details |
