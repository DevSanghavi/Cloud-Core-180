# Day 63: EC2 Security Groups Deep Dive

## What is this day and topic called?
This lesson is **Day 63 of the Cloud-Core-180 training curriculum**. The topic is called **EC2 Security Groups Deep Dive**.

## Why did we do this?
We performed this exercise to understand how infrastructure-level firewalls protect cloud servers. By controlling inbound rules programmatically through the AWS CLI, we learn how to restrict malicious access while still allowing authorized users and client applications to connect seamlessly.

## What happened by doing this?
1. We successfully configured an isolated network firewall profile (`Security Group`).
2. We restricted administration access (`SSH / Port 22`) strictly to our local workstation IP footprint.
3. We opened public web traffic (`HTTP / Port 80`) globally, verified it delivered an Nginx default web layout, and then revoked that permission instantly.
4. We verified that removing a Security Group rule cuts off live connection capabilities immediately without restarting or touching the underlying operating system.

## Why is it necessary to learn this topic?
- **Data Protection**: Leaving server ports open to the public (`0.0.0.0/0`) allows bad actors to attempt brute-force hacking entries on your systems.
- **Principle of Least Privilege**: It is a core global IT safety standard to only open required ports to trusted resources.
- **Enterprise Engineering Roles**: Every cloud architect, sysadmin, or DevOps engineer must configure network flow barriers daily. Security group topology is always featured heavily during technical architecture cloud interviews.

## Git Version Control Commands
Run these commands in your terminal once your code and documentation are ready:

```bash
git add README.md
git commit -m "docs: complete day 63 ec2 security groups explanation and practice tracker"
git push origin main
```
