# Day 143/180 — Project 3, Day 8: Health Dashboard
## Project: DevOps Monitoring Suite
This project builds a monitoring and operations suite for the existing Project 1 EC2 instance. It uses CloudWatch Agent metrics, CloudWatch alarms, SNS notifications, automated log backups to S3, systemd scheduling, log rotation, and a simple Nginx-served health dashboard. The existing Project 1 and Project 2 stacks remain running and are monitored, not recreated.
## Project Repository
https://github.com/DevSanghavi/devops-monitoring-suite
All code for this day lives in the project repo above.
## Today
Add a simple HTML health dashboard at `/dashboard`, served by the existing Nginx container through its host bind-mount configuration.
