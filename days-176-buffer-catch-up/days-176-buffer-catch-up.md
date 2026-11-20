# Day 176 — Buffer: Catch up on any incomplete labs

## Goal

Close the Docker logging gap by understanding and verifying the difference between the `json-file` and `awslogs` logging drivers without changing any running project resource.

## Weak Spot

Docker logging drivers determine where container logs are stored.

| Driver | Where logs go | How to read logs | Use case |
|---|---|---|---|
| `json-file` | Local Docker log files on the EC2 host | `docker logs CONTAINER_NAME` | Local troubleshooting and backup scripts |
| `awslogs` | AWS CloudWatch Logs | CloudWatch Logs console or AWS CLI | Centralized cloud log storage and retention |

A container can use only one configured logging driver at a time. The P1 Nginx container currently uses `json-file`, so its logs are stored locally and can be read with `docker logs`.

## Key Facts

- `json-file` stores logs locally in Docker's logging directory.
- `awslogs` sends logs to a configured CloudWatch Logs log group.
- `awslogs` requires an EC2 instance role with permission to write to CloudWatch Logs.
- An `awslogs` container may have an empty or unavailable local `LogPath` because logs are sent to CloudWatch.
- Container IDs and log paths can change after a container is recreated; container names remain stable references.
- Do not delete logs to solve disk pressure; investigate usage first, then rotate or compress logs.

## Read-Only Checks

Run from `~/cloud-practice/devops-monitoring-suite` after loading the project environment:

```bash
cd ~/cloud-practice/devops-monitoring-suite
source .env
```

### 1. Check the Nginx logging driver

```bash
ssmrun "docker inspect --format '{{.Name}} {{.HostConfig.LogConfig.Type}}' terraform-aws-infra-nginx"
```

Expected: `/terraform-aws-infra-nginx json-file`.

### 2. Check all running container logging drivers

```bash
ssmrun "docker ps --format '{{.Names}}' | while read c; do docker inspect --format '{{.Name}} {{.HostConfig.LogConfig.Type}}' \"$c\"; done"
```

Expected: each running container name appears with its configured logging driver.

### 3. Read recent Nginx logs locally

```bash
ssmrun "docker logs --tail 10 terraform-aws-infra-nginx"
```

Expected: the last 10 Nginx log lines appear because the container uses `json-file`.

### 4. Check disk usage before any cleanup decision

```bash
ssmrun "df -h"
```

Expected: filesystem usage is visible; do not delete anything based on this output alone.

### 5. Check Docker log directory size

```bash
ssmrun "du -sh /var/lib/docker/containers 2>/dev/null"
```

Expected: the total size of Docker container logs is displayed; this is read-only and does not modify logs.

## Decision Guide

| Situation | Correct action |
|---|---|
| Need to troubleshoot a container quickly | Use `docker logs CONTAINER_NAME` |
| Need centralized logs across restarts | Use `awslogs` with an IAM role and CloudWatch Logs |
| Disk usage is high | Run `df -h` and `du`, identify large files, then rotate or compress logs |
| Log file is empty | Check whether the container uses `awslogs`; its local `LogPath` may be empty |
| Need to identify a container | Use its stable container name, not its changing container ID |

## Lab Notes

| Check | Command | Result | Understanding |
|---|---|---|---|
| Nginx driver | `docker inspect ...` |  |  |
| All drivers | `docker ps` and `docker inspect` |  |  |
| Local logs | `docker logs --tail 10` |  |  |
| Disk usage | `df -h` |  |  |
| Docker log size | `du -sh /var/lib/docker/containers` |  |  |

## Rules Followed

- No AWS create, modify, delete, terminate, or destroy command was used.
- No Docker container was restarted, removed, or reconfigured.
- No project repository was edited or pushed from this exercise.
- No logs were deleted.
- No secrets, credentials, account IDs, or private values were included in notes or screenshots.
