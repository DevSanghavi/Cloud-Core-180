# Day 177 — Buffer: Deep dive into weakest topic

## Goal

Build a safe, repeatable response plan for a disk-full incident on the EC2 instance without deleting active application data or project resources.

## Incident Scenario

A CloudWatch disk alarm fires because disk usage crosses 85 percent. The EC2 instance hosts the P1 Flask application, Nginx reverse proxy, P2 production and staging APIs, and daily log backups.

The goal is to identify what is consuming space, reduce avoidable log growth, and preserve application availability.

## Incident Response Plan

1. Confirm the alarm and identify the affected instance.
2. Check overall filesystem usage.
3. Identify the largest directories and files.
4. Check Docker container log usage.
5. Rotate or compress logs where safe.
6. Verify application health after any safe cleanup.
7. Document the root cause and prevention step.

Never start by deleting files. Never delete databases, application data, configuration files, credentials, or project repositories.

## Read-Only Investigation Commands

Run from `~/cloud-practice/devops-monitoring-suite` after loading the project environment:

```bash
cd ~/cloud-practice/devops-monitoring-suite
source .env
```

### 1. Check overall disk usage

```bash
ssmrun "df -h"
```

Expected: the root filesystem usage percentage and available space are visible.

### 2. Find the largest directories under `/var/log`

```bash
ssmrun "du -h --max-depth=2 /var/log 2>/dev/null | sort -rh | head -n 15"
```

Expected: the largest log directories and files are listed in descending size order.

### 3. Find the largest files under `/var/log`

```bash
ssmrun "find /var/log -type f -printf '%s %p\n' 2>/dev/null | sort -nr | head -n 15"
```

Expected: the largest log files are listed with their sizes and paths.

### 4. Check Docker container log usage

```bash
ssmrun "du -sh /var/lib/docker/containers 2>/dev/null"
```

Expected: the total size of Docker container logs is displayed.

### 5. Identify the largest Docker container log files

```bash
ssmrun "find /var/lib/docker/containers -type f -name '*-json.log' -printf '%s %p\n' 2>/dev/null | sort -nr | head -n 10"
```

Expected: the largest Docker JSON log files are listed with their sizes and paths.

### 6. Check memory and running processes

```bash
ssmrun "free -h && ps aux --sort=-%mem | head -n 10"
```

Expected: memory usage and the highest-memory processes are visible; this helps determine whether a process is generating excessive logs.

## Safe Cleanup Options

| Situation | Safe action |
|---|---|
| Application log is very large | Rotate or compress the log using the configured logrotate policy |
| Old compressed backup exists locally | Move or archive it only after confirming it is no longer needed |
| Docker log is very large | Investigate the application first; rotate logs using the configured Docker logging configuration |
| Temporary file is no longer needed | Remove only that specific verified temporary file |
| Unknown large file | Investigate its owner, purpose, and age before taking action |
| Database, application data, or configuration file | Do not delete; escalate or restore from backup if needed |

## Logrotate Understanding

`logrotate` prevents log files from growing indefinitely by rotating, compressing, and optionally removing old logs according to a configured policy.

A safe logrotate policy should:

- Rotate logs on a defined size or time schedule.
- Compress rotated logs.
- Retain a limited number of old logs.
- Reload or signal the application only when required.
- Never delete the active application database or configuration.

## Verification After Safe Cleanup

After rotating or compressing a log, verify that the application is still healthy:

```bash
curl -sS -o /dev/null -w "HTTP %{http_code}\n" "http://$EC2_PUBLIC_IP/health"
```

Expected: `HTTP 200`.

Then recheck disk usage:

```bash
ssmrun "df -h"
```

Expected: available space increases or remains stable; no project resource is deleted.

## Incident Documentation Template

```text
Incident: High disk usage alarm
Affected instance: P1 EC2 application server
Detected by: CloudWatch disk utilization alarm
Initial impact: [DESCRIBE ACTUAL IMPACT]
Investigation findings: [RECORD ACTUAL FINDINGS]
Action taken: [RECORD SAFE ACTION]
Verification: [RECORD HEALTH CHECK RESULT]
Root cause: [RECORD ACTUAL ROOT CAUSE]
Prevention: [RECORD LOG ROTATION OR MONITORING IMPROVEMENT]
```

## Rules Followed

- No AWS create, modify, delete, terminate, or destroy command was used.
- No Docker container was restarted, removed, or reconfigured.
- No log, application file, database, or project resource was deleted.
- Only read-only investigation commands were used.
- No secrets, credentials, account IDs, or private values were included in notes or screenshots.
