# Day 162 — Project 2 Polish: Final run, screenshot results, write LinkedIn announcement

## Goal

Complete the final read-only validation of `gitops-cicd-pipeline`, collect screenshot evidence, and write a LinkedIn announcement based only on the actual P2 project.

## Project 2

Repository: https://github.com/DevSanghavi/gitops-cicd-pipeline

P2 is a GitOps CI/CD pipeline that builds and publishes a container image, deploys production and staging APIs, supports a release PR flow, and provides a Rollback Production workflow using the previous image digest. The production API is proxied by the P1 Nginx container, while staging runs on host port 8080.

## Final Run Checks

Run from `~/cloud-practice/devops-monitoring-suite` after loading the project environment:

```bash
cd ~/cloud-practice/devops-monitoring-suite
source .env
```

### 1. Verify production and staging containers are running

```bash
aws ssm send-command --profile "$PROFILE" --region "$REGION" --instance-ids "$EC2_INSTANCE_ID" --document-name "AWS-RunShellScript" --comment "P2 final container check" --parameters '{"commands":["docker ps --format \"table {{.Names}}\\t{{.Status}}\\t{{.Ports}}\""]}' --output json
```

Expected: `project2-production-api` and `project2-staging-api` appear with status `Up` and `(healthy)`.

### 2. Retrieve the SSM command result

Copy the `CommandId` value returned by the previous command, then run:

```bash
aws ssm get-command-invocation --profile "$PROFILE" --region "$REGION" --command-id "PASTE_THE_COMMAND_ID_HERE" --instance-id "$EC2_INSTANCE_ID" --query '{Status:Status,Output:StandardOutputContent}' --output json
```

Type the actual `CommandId` between the quotation marks; it is a temporary command identifier returned by AWS SSM and cannot be known before the command is submitted.

Expected: `Status` is `Success`; output shows both P2 containers as `Up` and healthy.

### 3. Verify production API health through Nginx

```bash
curl -sS -o /dev/null -w "HTTP %{http_code}\n" "http://$EC2_PUBLIC_IP/health"
```

Expected: `HTTP 200`.

### 4. Verify production API response

```bash
curl -sS "http://$EC2_PUBLIC_IP/health"
```

Expected: JSON showing `"status":"ok"`, `"environment":"production"`, `"database":"ok"`, and the current production image digest.

### 5. Verify staging API health

```bash
curl -sS -o /dev/null -w "HTTP %{http_code}\n" "http://$EC2_PUBLIC_IP:8080/health"
```

Expected: `HTTP 200`.

### 6. Verify staging API response

```bash
curl -sS "http://$EC2_PUBLIC_IP:8080/health"
```

Expected: JSON showing `"status":"ok"`, `"environment":"staging"`, `"database":"ok"`, and the current staging image digest.

### 7. Verify GitHub Actions workflows

Open the repository Actions page in the browser and confirm:

- The latest CI workflow run is successful.
- The latest deployment workflow run is successful.
- The Rollback Production workflow exists and has a successful run history or is ready to run.
- The release PR flow is documented or visible in the repository.

Do not trigger a deployment, rollback, or workflow manually for this polish exercise.

## Screenshot Checklist

Capture and save these screenshots in a local folder outside the project repositories, for example `~/cloud-practice/screenshots/p2-final/`:

1. GitHub repository home page showing `DevSanghavi/gitops-cicd-pipeline`.
2. GitHub Actions page showing the latest successful CI workflow.
3. GitHub Actions page showing the latest successful deployment workflow.
4. GitHub Actions page showing the Rollback Production workflow.
5. SSM command result showing both P2 containers are `Up` and healthy.
6. Terminal output showing production `/health` returns `HTTP 200`.
7. Terminal output showing production health JSON with `environment: production`.
8. Terminal output showing staging `/health` returns `HTTP 200`.
9. Terminal output showing staging health JSON with `environment: staging`.
10. README section showing architecture, setup, deployment, rollback, and release PR instructions.

Do not upload `.env`, private keys, credentials, tokens, account IDs, or any secret values.

## LinkedIn Announcement

Post this text after confirming all checks pass:

```text
Completed Project 2: GitOps CI/CD Pipeline.

I built a CI/CD workflow that automates container image builds, deployments, release reviews, and production rollbacks.

Key work:
- Built and published a container image through GitHub Actions.
- Deployed separate production and staging API environments.
- Used a release pull request flow for controlled changes.
- Added a Rollback Production workflow using the previous image digest.
- Verified production and staging API health endpoints.
- Documented the deployment and rollback process.

Repository:
[https://github.com/DevSanghavi/gitops-cicd-pipeline](https://github.com/DevSanghavi/gitops-cicd-pipeline)

This project strengthened my practical skills in GitHub Actions, Docker, GitOps, CI/CD, container deployments, and production rollback planning.

#GitHubActions #CI/CD #GitOps #Docker #DevOps #CloudComputing #Automation
```

## Evidence Log

| Check | Command or location | Expected result | Screenshot saved |
|---|---|---|---|
| P2 containers | SSM `docker ps` result | Both containers `Up` and healthy | Yes |
| Production health | `curl /health` | `HTTP 200` and production JSON | Yes |
| Staging health | `curl :8080/health` | `HTTP 200` and staging JSON | Yes |
| CI workflow | GitHub Actions | Latest run successful | Yes |
| Deployment workflow | GitHub Actions | Latest run successful | Yes |
| Rollback workflow | GitHub Actions | Workflow present | Yes |
| README | Repository | Deployment and rollback documented | Yes |

## Rules Followed

- No AWS create, modify, delete, terminate, or destroy commands were used.
- P2 repository was not edited or pushed from this exercise.
- No deployment, rollback, or workflow was manually triggered.
- No secrets, credentials, account IDs, or private values were included in screenshots or the LinkedIn post.
- All claims are based on the actual P2 project and verified outputs.
