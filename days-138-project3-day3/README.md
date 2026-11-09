# Day 138/180 — Project 3, Day 3: CloudWatch Alarms
## Project: DevOps Monitoring Suite
This project builds a monitoring and operations suite for the existing Project 1 EC2 instance. It uses CloudWatch Agent metrics, CloudWatch alarms, SNS notifications, automated log backups to S3, systemd scheduling, log rotation, and a simple Nginx-served health dashboard. The existing Project 1 and Project 2 stacks remain running and are monitored, not recreated.
## Project Repository
https://github.com/DevSanghavi/devops-monitoring-suite
All code for this day lives in the project repo above.
## Today
Create CPU, memory, and disk CloudWatch alarms for the existing EC2. CPU uses the AWS-provided CPUUtilization metric, while memory and disk use the custom metrics published by the CloudWatch Agent on Day 137.
