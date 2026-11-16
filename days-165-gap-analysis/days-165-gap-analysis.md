# Day 165 — Gap Analysis: Revisit any weak days from the past 100 days

## Goal

Close the remaining practical gaps from the past 100 days by revisiting weak spots, incident lessons, and correct troubleshooting habits.

## Weak Spots

| Gap | Correct understanding | Practice command |
|---|---|---|
| `awslogs` vs `json-file` | `json-file` is the Docker logging driver that stores container logs locally; `awslogs` sends container logs to AWS CloudWatch Logs. | `docker inspect --format '{{.HostConfig.LogConfig.Type}}' terraform-aws-infra-nginx` |
| Disk full response | Investigate usage first, rotate or compress logs, then remove only safe expired files; never delete project data or run destructive cleanup first. | `df -h` |
| Container IDs and log paths | Container IDs and log file paths can change after recreation; container and service names remain stable references. | `docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'` |
| Single-file vs directory bind mount | A single-file bind mount maps one host file into the container; a directory bind mount maps an entire host directory. A directory must exist before mounting it. | `docker inspect --format '{{json .Mounts}}' terraform-aws-infra-nginx` |

## Incident Lessons

| Incident | Root cause | Correct prevention |
|---|---|---|
| Git run from wrong folder | Commands were run outside the intended repository. | Run `pwd` and `git status` before committing or pushing. |
| RDS subnet group needed 2 AZs | A DB subnet group requires subnets in at least two Availability Zones. | Plan at least two private subnets in separate AZs before creating RDS. |
| Terraform CD missing DB password secret | The workflow did not provide the required secret. | Add required secrets in GitHub repository settings and reference them explicitly in the workflow. |
| Local AWS profile in Terraform backend | The backend configuration referenced a local profile unavailable on the runner. | Use environment-based AWS credentials or a backend configuration suitable for CI. |
| Dockerfile copied `node_modules` | A host-generated dependency folder was copied into the image. | Use `.dockerignore` and install dependencies inside the image build. |
| `npm ci` without lockfile | `npm ci` requires a lockfile for deterministic installation. | Commit `package-lock.json` and run `npm ci` in CI. |
| `better-sqlite3` needed Node 22 | The base image used Node 18, which was incompatible with the dependency requirement. | Match the Node version in the Dockerfile to the dependency requirement. |
| Bash case glob `{64}` failed | Brace expansion did not behave as intended in the test. | Use `[[ "$value" =~ pattern ]]` for reliable matching. |
| Nginx bind mount read-only | The container could not write to a host-mounted file. | Write host configuration files using `sudo tee`, then reload or restart only the required service. |
| `awslogs` needed EC2 instance role | The instance lacked permission to write to CloudWatch Logs. | Attach an IAM role with the minimum required CloudWatch Logs permissions. |
| SSH timeout after home IP change | The home public IP changed and the security group no longer allowed it. | Use SSM for EC2 command execution instead of relying on a changing home IP. |
| Disk alarm `INSUFFICIENT_DATA` | Alarm dimensions did not match the metric dimensions. | Use the exact instance and device dimensions in the alarm configuration. |
| AWS CLI missing on EC2 | The instance did not have the AWS CLI installed. | Install the required CLI during provisioning or use SSM automation where appropriate. |
| `awslogs` empty `LogPath` | The awslogs driver does not expose a local JSON log path. | Use `docker logs` or CloudWatch Logs depending on the configured driver. |
| Tar empty member | The backup command referenced an empty or missing file. | Verify the source file exists and has content before archiving it. |
| SSM JSON quoting | Shell quoting changed the JSON passed to SSM. | Use single quotes around the JSON and escape inner quotes correctly. |

## Focused Practice

### 1. Identify Docker logging driver

```bash
docker inspect --format '{{.HostConfig.LogConfig.Type}}' terraform-aws-infra-nginx
```

Expected: the configured Docker logging driver, such as `awslogs` or `json-file`.

### 2. Check disk usage before cleanup

```bash
df -h
```

Expected: filesystem usage is visible; identify the filesystem and usage percentage before considering any cleanup.

### 3. Confirm stable container names

```bash
docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
```

Expected: stable container names appear, including `terraform-aws-infra-nginx`, `terraform-aws-infra-flask`, `project2-production-api`, and `project2-staging-api`.

### 4. Inspect bind mounts

```bash
docker inspect --format '{{json .Mounts}}' terraform-aws-infra-nginx
```

Expected: the Nginx configuration mount type and source/destination paths are visible.

## Gap Closure Checklist

| Topic | Can explain it | Can troubleshoot it | Can prevent it |
|---|---|---|---|
| Docker logging drivers | Yes/No | Yes/No | Yes/No |
| Disk-full response | Yes/No | Yes/No | Yes/No |
| Container names versus IDs | Yes/No | Yes/No | Yes/No |
| Bind mounts | Yes/No | Yes/No | Yes/No |
| Git repository context | Yes/No | Yes/No | Yes/No |
| RDS subnet requirements | Yes/No | Yes/No | Yes/No |
| GitHub Actions secrets | Yes/No | Yes/No | Yes/No |
| SSM command quoting | Yes/No | Yes/No | Yes/No |
| Alarm dimensions | Yes/No | Yes/No | Yes/No |
| Backup validation | Yes/No | Yes/No | Yes/No |

## Rules Followed

- No AWS create, modify, delete, terminate, or destroy commands were used.
- P1, P2, and P3 running resources remain untouched.
- No project repository was edited or pushed from this exercise.
- No secrets, credentials, account IDs, or private values were included in notes or screenshots.
