# Day 146/180 — Phase 7, Day 1: Linux Scenarios

## Scenario 1 — Server is slow

### Symptom
The EC2 instance responds slowly, API requests take longer, or the Nginx production site feels delayed.

### Likely causes
1. High CPU usage from a runaway process.
2. High memory usage causing swapping or process pressure.
3. Disk pressure affecting logging or application performance.
4. A container consuming excessive resources.
5. A genuine application or database bottleneck.

### Triage
Run from `~/cloud-practice/devops-monitoring-suite` after `source .env`.

```bash
uptime
```

Meaning: shows load average and uptime. Compare the one-minute load average with the instance vCPU count; a `t3.micro` has one vCPU, so sustained load above 1.0 needs investigation.

```bash
top -b -n 1 | head -n 20
```

Meaning: identifies the highest CPU and memory processes. Check whether the top process is Docker, a container workload, or an unexpected process.

```bash
free -h
```

Meaning: shows total, used, and available memory. Low `available` memory can cause performance degradation.

```bash
df -h
```

Meaning: shows filesystem usage. A nearly full root volume can slow writes and affect logs or databases.

```bash
docker ps
```

Meaning: confirms which containers are running and whether any are restarting or unhealthy.

```bash
docker stats --no-stream
```

Meaning: shows current CPU and memory use per container without opening a live dashboard.

```bash
ssmrun "uptime && free -h && df -h && docker ps"
```

Meaning: performs the first-pass remote health check through SSM without opening an SSH session.

### Fix
1. Identify the highest CPU or memory process using `top`.
2. If it is a container, inspect its logs and recent deployment changes before restarting it.
3. If memory is exhausted, identify the container or process responsible; do not blindly restart services.
4. If disk usage is high, investigate large logs and rotate or archive them according to the existing logrotate and S3 backup process.
5. If the issue began after a deployment, compare the current container image digest and application logs with the previous release.
6. Escalate to resizing only after confirming that the workload genuinely needs more capacity.

### Prevention
- Keep CloudWatch CPU, memory, and disk alarms active.
- Review `docker stats` during deployments.
- Keep log rotation enabled and verify backup jobs.
- Document the normal baseline for CPU, memory, disk, and container count.

### Real incident
During my disk alarm investigation, the CloudWatch alarm stayed in `INSUFFICIENT_DATA` because the alarm metric dimensions did not match the actual disk metric dimensions. Once the dimensions matched, the alarm evaluated correctly. This taught me that a monitoring gap can look like a server problem when the metric is not being collected properly.

### 30-second interview answer
“When a server is slow, I first establish the symptom and check the cheapest signals: uptime for load, `top` for the top process, `free -h` for memory pressure, and `df -h` for disk capacity. Then I check container health and resource use with `docker ps` and `docker stats`. I avoid restarting anything until I know what changed, and I use logs and CloudWatch alarms to correlate the issue with a deployment or resource spike.”

## Scenario 2 — Disk is full

### Symptom
The disk alarm fires, commands fail with `No space left on device`, logs stop writing, or containers behave unexpectedly.

### Likely causes
1. Application or container logs have grown.
2. Docker images, build cache, or unused volumes have accumulated.
3. Backup files are retained too long.
4. A large file was accidentally written to the root volume.
5. The disk was undersized for the workload.

### Triage
Run from `~/cloud-practice/devops-monitoring-suite` after `source .env`.

```bash
ssmrun "df -h"
```

Meaning: confirms which filesystem is full and how much space remains.

```bash
ssmrun "du -h --max-depth=1 / 2>/dev/null | sort -rh | head -n 15"
```

Meaning: identifies the largest top-level directories. This is read-only and does not remove anything.

```bash
ssmrun "du -h --max-depth=2 /var/log 2>/dev/null | sort -rh | head -n 20"
```

Meaning: finds whether logs are consuming the space.

```bash
ssmrun "docker system df"
```

Meaning: shows Docker image, container, volume, and build-cache usage.

```bash
ssmrun "docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Image}}'"
```

Meaning: identifies stopped containers and their images before considering cleanup.

```bash
ssmrun "journalctl --disk-usage"
```

Meaning: shows how much space systemd journal logs use.

### Fix
1. Confirm the filesystem and directory consuming space before deleting anything.
2. Rotate or compress old application logs using the existing logrotate configuration.
3. Verify that the daily systemd-timer backup completed and that required logs are safely stored in S3.
4. Remove only verified, non-needed old logs after confirming retention requirements.
5. If Docker artifacts are the cause, inspect `docker system df` first and remove only confirmed unused artifacts using the appropriate Docker cleanup command; never run destructive cleanup as a first response.
6. If the workload legitimately needs more storage, plan an EBS volume resize through the approved infrastructure process.

### Prevention
- Keep logrotate active and test its configuration.
- Retain only the required number of backup generations.
- Monitor disk usage before it reaches the 85 percent alarm threshold.
- Document what may be safely removed and what must be preserved.

### Real incident
My disk alarm initially showed `INSUFFICIENT_DATA`, so I could not trust it as evidence of a disk problem. After matching the CloudWatch metric dimensions, the alarm became useful. This reinforced my rule: investigate the monitoring configuration before treating an alert absence or alert state as proof of the underlying issue.

### 30-second interview answer
“When disk is full, I do not delete files first. I confirm the affected filesystem with `df -h`, find the largest directories with `du`, inspect Docker usage with `docker system df`, and check journal usage with `journalctl --disk-usage`. Then I rotate or archive logs only after confirming backups and retention requirements. My rule is investigate, preserve evidence, rotate safely, and only then clean up.”

## Scenario 3 — Service won't start

### Symptom
A systemd service, Docker container, or Nginx proxy is not running, and the application is unavailable.

### Likely causes
1. The service failed during startup because of a configuration error.
2. A required port is already in use.
3. A bind-mounted configuration file is missing, invalid, or unreadable.
4. A dependency such as a database or upstream API is unavailable.
5. The service crashed after starting and is repeatedly restarting.

### Triage
Run from `~/cloud-practice/devops-monitoring-suite` after `source .env`.

```bash
ssmrun "systemctl --failed"
```

Meaning: lists systemd units that failed.

```bash
ssmrun "systemctl status nginx --no-pager -l"
```

Meaning: shows whether Nginx is active, failed, or inactive, plus recent log lines.

```bash
ssmrun "journalctl -u nginx -n 50 --no-pager"
```

Meaning: shows the most recent Nginx service logs and startup errors.

```bash
ssmrun "docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Image}}'"
```

Meaning: distinguishes a running container from one that exited or is restarting.

```bash
ssmrun "docker logs --tail 50 terraform-aws-infra-nginx"
```

Meaning: shows the Nginx container’s recent output and configuration errors.

```bash
ssmrun "docker port terraform-aws-infra-nginx"
```

Meaning: confirms the container port mapping.

```bash
ssmrun "curl -I http://127.0.0.1:80"
```

Meaning: checks whether Nginx is accepting requests locally.

```bash
curl -I "http://${EC2_PUBLIC_IP}:80"
```

Meaning: checks the public HTTP path from the workstation and helps separate a local service issue from a security-group or network issue.

### Fix
1. Read the exact error in `journalctl` or `docker logs` before changing configuration.
2. If Nginx reports a configuration error, validate the configuration with `nginx -t` before restarting.
3. If a port conflict is reported, identify the process or container already using the port and correct the configuration or stop the conflicting service through the approved change process.
4. If a bind mount is the problem, verify that the host file exists, has correct permissions, and is mounted as a file rather than a directory.
5. If the upstream API is unavailable, check the API container status and logs before changing Nginx.
6. Restart only after identifying the cause, then verify the service with `systemctl status`, `docker ps`, and an HTTP check.

### Prevention
- Validate Nginx configuration before deployment.
- Use explicit host-file bind mounts, not accidental directory mounts.
- Keep container names stable because IDs and log paths can change.
- Add health checks and alerts for the production Nginx and API containers.

### Real incident
My Nginx configuration used a host bind mount, and I learned that writing to a single-file bind mount from inside the container can fail because of mount semantics. The practical fix was to update the host configuration file using `sudo tee`, then reload or restart Nginx through the approved process. This taught me to distinguish a container configuration issue from a host bind-mount issue.

### 30-second interview answer
“When a service will not start, I first read its failure evidence: `systemctl status`, `journalctl`, and, for containers, `docker logs`. I check whether the port is occupied, whether a bind-mounted config file is valid and readable, and whether the upstream dependency is healthy. I fix the specific cause, validate the configuration, restart only when needed, and verify with both a local and external HTTP check.”

## Interview Rule

For every Linux incident, follow this order: **confirm the symptom, inspect evidence, identify the cause, apply the smallest safe fix, verify recovery, and prevent recurrence.**
