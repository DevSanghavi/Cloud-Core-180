# Day 154/180 — Phase 7, Day 9: Incident Response — The website is down

## Incident Goal

Confirm the scope, restore service safely, identify the root cause, and document the incident. Start with the cheapest checks and avoid changing infrastructure before collecting evidence.

## Step-by-Step Triage Checklist

Run from `~/cloud-practice/devops-monitoring-suite` after `source .env`.

### 1. Confirm the outage

```bash
curl -I --max-time 10 "http://${EC2_PUBLIC_IP}:80"
```

Meaning: checks the public production HTTP endpoint. A timeout suggests a network, security-group, instance, or routing issue; an HTTP error suggests the service is reachable but unhealthy.

```bash
curl -I --max-time 10 "http://${EC2_PUBLIC_IP}:8080"
```

Meaning: checks the staging API endpoint. Comparing production and staging helps determine whether the issue is isolated to production.

Expected result: production port 80 should return an HTTP status; staging port 8080 should also respond if its service is healthy.

### 2. Check the EC2 instance

```bash
aws ec2 describe-instances \
  --instance-ids "$EC2_INSTANCE_ID" \
  --query 'Reservations[].Instances[].{InstanceId:InstanceId,State:State.Name,PublicIp:PublicIpAddress,SubnetId:SubnetId,VpcId:VpcId,SecurityGroups:SecurityGroups}' \
  --output table
```

Meaning: confirms that the EC2 instance is running and has the expected public IP, subnet, VPC, and security groups.

```bash
nc -vz -w 5 "$EC2_PUBLIC_IP" 80
```

Meaning: tests whether TCP port 80 is reachable. A timeout points toward networking or security-group configuration; a refusal points toward the service or listener.

Expected result: `succeeded` for port 80 when the network path and Nginx listener are healthy.

### 3. Check containers

```bash
ssmrun "docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"
```

Meaning: confirms whether the Nginx container, production API container, staging API container, and Project 1 Flask container are running.

```bash
ssmrun "docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Image}}'"
```

Meaning: identifies containers that exited, restarted, or are unhealthy.

```bash
ssmrun "docker port terraform-aws-infra-nginx"
```

Meaning: verifies that the Nginx container is publishing host port 80.

Expected result: `terraform-aws-infra-nginx` should be running and publish host port 80.

### 4. Check Nginx

```bash
ssmrun "docker logs --tail 100 terraform-aws-infra-nginx"
```

Meaning: shows recent Nginx errors, upstream failures, configuration errors, or restart messages.

```bash
ssmrun "curl -I http://127.0.0.1:80"
```

Meaning: tests Nginx locally on the EC2 host, separating a local service issue from an external network issue.

```bash
ssmrun "docker logs --tail 100 PRODUCTION_API_CONTAINER_NAME"
```

Meaning: shows whether the upstream production API is failing, crashing, or unable to reach RDS.

Expected result: Nginx should respond locally on port 80, and the production API logs should not show repeated startup or upstream errors.

### 5. Check alarms and metrics

```bash
aws cloudwatch describe-alarms \
  --query 'MetricAlarms[].{AlarmName:AlarmName,State:StateValue,Reason:StateReason,MetricName:MetricName}' \
  --output table
```

Meaning: identifies whether CPU, memory, or disk alarms are firing and shows the reason for the current state.

```bash
aws cloudwatch get-metric-statistics \
  --namespace AWS/EC2 \
  --metric-name CPUUtilization \
  --dimensions Name=InstanceId,Value="$EC2_INSTANCE_ID" \
  --start-time "$(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%SZ)" \
  --end-time "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  --period 300 \
  --statistics Average,Maximum \
  --output table
```

Meaning: checks whether high CPU correlates with the outage.

```bash
aws cloudwatch get-metric-statistics \
  --namespace AWS/RDS \
  --metric-name DatabaseConnections \
  --dimensions Name=DBInstanceIdentifier,Value="$RDS_INSTANCE_ID" \
  --start-time "$(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%SZ)" \
  --end-time "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  --period 300 \
  --statistics Maximum \
  --output table
```

Meaning: checks whether database connection growth correlates with the outage.

Expected result: alarms should be `OK` or provide a clear reason if they are in `ALARM` or `INSUFFICIENT_DATA`.

### 6. Check CloudWatch Logs

```bash
aws logs describe-log-groups \
  --query 'logGroups[].logGroupName' \
  --output table
```

Meaning: lists available CloudWatch Logs log groups.

```bash
aws logs tail LOG_GROUP_NAME --since 1h --follow
```

Meaning: streams recent logs from the selected log group. Stop following with `Ctrl + C`.

```bash
aws logs filter-log-events \
  --log-group-name LOG_GROUP_NAME \
  --start-time "$(date -u -d '1 hour ago' +%s)000" \
  --filter-pattern "ERROR" \
  --query 'events[].message' \
  --output text
```

Meaning: searches recent application or container logs for errors.

Expected result: recent logs should identify the failing component, such as Nginx, the API container, RDS connectivity, or an application error.

## Recovery Decision Guide

| Evidence | Likely failure layer | Safe next action |
|---|---|---|
| Public port 80 times out; instance is running | Security group, route table, public IP, or network path | Check security-group inbound rules, route table, and public IP before changing containers |
| Public port 80 times out; local Nginx check succeeds | External network path | Investigate security group, routing, or public IP configuration |
| Local Nginx check fails | Nginx container or configuration | Read Nginx logs, validate configuration, then restart only after identifying the cause |
| Nginx responds but API returns errors | Production API container or RDS | Check API logs, container status, and RDS connectivity |
| CPU, memory, or disk alarm is firing | Resource pressure | Investigate the resource consumer before restarting or resizing |
| Failure began after deployment | Recent release | Compare the current image digest and configuration with the last known-good release |

## Communication Template

```text
Incident: Production website is unavailable.
Impact: Users cannot access the production site on port 80.
Current status: Investigating.
Evidence: Public HTTP check, EC2 state, container status, Nginx logs, alarms, and CloudWatch Logs are being reviewed.
Next update: Will share findings and recovery status after the next check.
```

## 30-Second Interview Answer

“When a website is down, I start with the cheapest checks: confirm the public HTTP endpoint, test staging, verify the EC2 instance state, and test TCP connectivity. Then I check container status, Nginx logs, local HTTP response, CloudWatch alarms, and application logs. I separate a network issue from an application issue before changing anything, and I communicate impact, evidence, and next steps throughout the incident.”
