# Day 179 — Buffer: Final confidence review and cheat-sheet creation

## Goal

Create a concise, reusable cheat sheet covering the core tools, workflows, troubleshooting steps, and project facts from the 180-day roadmap.

## Core Commands Cheat Sheet

| Task | Command |
|---|---|
| Check disk usage | `df -h` |
| Find largest directories | `du -h --max-depth=2 /var/log 2>/dev/null | sort -rh | head -n 15` |
| Find largest files | `find /var/log -type f -printf '%s %p\n' 2>/dev/null | sort -nr | head -n 15` |
| Check Docker containers | `docker ps` |
| Check Docker images | `docker images` |
| View container logs | `docker logs <container-name>` |
| Follow container logs | `docker logs -f <container-name>` |
| Inspect a container | `docker inspect <container-name>` |
| Check Git status | `git status` |
| Check recent commits | `git log --oneline -5` |
| Push current branch | `git push origin <branch-name>` |
| Check Terraform state | `terraform state list` |
| Check Terraform configuration | `terraform fmt -check && terraform validate` |

## Docker Cheat Sheet

| Concept | Meaning |
|---|---|
| Image | Read-only template used to create containers |
| Container | Running instance of an image |
| Volume | Persistent storage outside the container filesystem |
| Bind mount | Maps a host directory or file into a container |
| Named volume | Docker-managed persistent storage with a stable name |
| Environment variable | Configuration passed into a container |
| Health check | Command used to determine whether a container is healthy |
| Restart policy | Defines whether Docker restarts a container after failure |

## Docker Logging Cheat Sheet

| Driver | Where logs go | Typical use |
|---|---|---|
| `json-file` | Local Docker log files on the host | Local development and direct troubleshooting |
| `awslogs` | Amazon CloudWatch Logs | Centralized AWS logging and retention |

Important: changing the logging driver affects where new logs are delivered; it does not automatically change the application's internal logging behavior.

## Terraform Cheat Sheet

| Command | Purpose |
|---|---|
| `terraform init` | Initialize a Terraform working directory |
| `terraform validate` | Validate configuration syntax and consistency |
| `terraform plan` | Preview planned infrastructure changes |
| `terraform apply` | Apply planned infrastructure changes |
| `terraform state list` | List resources tracked in Terraform state |
| `terraform output` | Show configured Terraform outputs |

Rule: use `terraform plan` before `terraform apply`; never apply changes without reviewing the plan.

## AWS Security Cheat Sheet

| Service | Purpose |
|---|---|
| IAM | Controls identities and permissions |
| Security group | Stateful virtual firewall for AWS resources |
| VPC | Isolated cloud network |
| Public subnet | Subnet with a route toward the internet |
| Private subnet | Subnet without a direct internet route |
| SSM | Secure instance management without exposing SSH |
| CloudWatch | Monitoring, alarms, logs, and metrics |
| RDS | Managed relational database service |

## P1 Architecture Cheat Sheet

```text
User
  |
  v
Nginx reverse proxy (EC2, port 80)
  |
  v
Flask application container
  |
  v
Private RDS MySQL database
```

Key facts:

- The Flask application runs in Docker.
- Nginx receives traffic on port 80 and proxies requests to the application.
- RDS is in private subnets and is not directly reachable from the internet.
- The production health endpoint returns HTTP 200.
- Terraform manages the infrastructure configuration and state.

## P2 Architecture Cheat Sheet

```text
User
  |
  v
Nginx reverse proxy (P1, port 80)
  |
  v
P2 production API container
  |
  v
P2 staging API container
```

Key facts:

- P2 has separate production and staging API containers.
- The production API is served through the P1 Nginx reverse proxy.
- The staging API runs on host port 8080.
- Container names provide stable references for operations and troubleshooting.

## Incident Response Cheat Sheet

| Incident | First safe action |
|---|---|
| Application down | Check container status, logs, health endpoint, and reverse proxy |
| High disk usage | Run `df -h`, identify largest directories and files, then rotate or compress logs |
| Docker log growth | Check container logs and logging configuration; investigate the application first |
| Database connectivity issue | Check security groups, network reachability, credentials configuration, and application logs |
| Deployment failure | Check Git status, CI/CD logs, Docker build logs, and application logs |
| Unknown large file | Investigate owner, purpose, and age before taking action |

## Troubleshooting Order

1. Confirm the symptom and scope.
2. Check recent changes.
3. Check application health.
4. Check container status and logs.
5. Check reverse proxy logs and configuration.
6. Check resource usage and disk space.
7. Check network and security-group configuration.
8. Apply the smallest safe fix.
9. Verify recovery.
10. Document the root cause and prevention.

## Confidence Review

| Area | Confidence level |
|---|---|
| Linux fundamentals | [RATE 1-5] |
| Git and GitHub | [RATE 1-5] |
| Docker | [RATE 1-5] |
| Terraform | [RATE 1-5] |
| AWS networking | [RATE 1-5] |
| AWS security | [RATE 1-5] |
| Monitoring and logging | [RATE 1-5] |
| Incident troubleshooting | [RATE 1-5] |
| Three-tier architecture | [RATE 1-5] |
| Project explanation | [RATE 1-5] |

## Final Revision Questions

1. Explain the P1 request flow from user to database.
2. Explain the difference between production and staging in P2.
3. Explain the difference between `json-file` and `awslogs`.
4. Explain how to investigate high disk usage safely.
5. Explain how Terraform state helps track infrastructure.
6. Explain how security groups protect the EC2 and RDS resources.
7. Explain how you would troubleshoot a failing container.
8. Explain how you would scale the current architecture.

## Rules Followed

- No AWS create, modify, delete, terminate, or destroy command was used.
- P1, P2, and P3 repositories and running resources remain untouched.
- All cheat-sheet content is based on completed project work and verified facts.
- No secrets, credentials, account IDs, or private values were included.
- No experience, employers, metrics, salaries, or company names were invented.
 
