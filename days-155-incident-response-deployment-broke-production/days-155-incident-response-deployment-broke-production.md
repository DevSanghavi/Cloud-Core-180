# Day 155/180 — Phase 7, Day 10: Incident Response — Deployment broke production

## Incident Goal

Restore production quickly using the last known-good image digest, preserve evidence for the root-cause investigation, and avoid making the incident worse through an unreviewed change.

## Rollback Decision Tree

```text
Deployment broke production
│
├── Is production currently unsafe or unavailable?
│   │
│   ├── YES → Declare the incident, notify stakeholders, and begin rollback.
│   │
│   └── NO → Assess impact, errors, and affected users before changing production.
│
├── Did the failure begin immediately after a deployment?
│   │
│   ├── YES → Treat the new release as the primary suspect.
│   │
│   └── NO → Investigate infrastructure, dependencies, database, and external services first.
│
├── Is a previous known-good image digest available?
│   │
│   ├── YES → Run the Rollback Production workflow with that digest.
│   │
│   └── NO → Do not guess a digest.
│       │
│       ├── Check GitHub Actions history and GHCR image tags.
│       ├── Identify the last successful production deployment.
│       └── If no safe previous version exists, stabilize or fix forward through a reviewed change.
│
├── Does rollback require a production environment change?
│   │
│   ├── YES → Update deploy/production.env through a release PR.
│   │
│   └── NO → Run the rollback workflow directly with the approved previous digest.
│
└── After rollback
    │
    ├── Verify production health with curl.
    ├── Check container status and logs.
    ├── Confirm CloudWatch alarms return to a healthy state.
    ├── Preserve logs, image digests, workflow runs, and deployment timeline.
    └── Open a root-cause investigation before attempting the next deployment.
```

## Rollback Workflow

Run from `~/cloud-practice/gitops-cicd-pipeline`.

### 1. Confirm the incident

```bash
curl -I --max-time 10 "http://${EC2_PUBLIC_IP}:80"
```

Meaning: checks whether production Nginx is responding.

```bash
curl -I --max-time 10 "http://${EC2_PUBLIC_IP}:8080"
```

Meaning: checks whether staging is still healthy and helps determine whether the issue is production-specific.

```bash
gh run list --limit 10
```

Meaning: identifies the deployment workflow run that may have caused the incident.

```bash
gh run view RUN_ID --log-failed
```

Meaning: shows the failed deployment step, if the workflow itself failed.

### 2. Identify the last known-good digest

```bash
gh run list --workflow deploy-production.yml --limit 10
```

Meaning: lists recent production deployment runs.

```bash
gh run view RUN_ID --log
```

Meaning: finds the image digest used by the last successful production deployment.

```bash
git log --oneline -n 10
```

Meaning: identifies the commit and release associated with the current and previous deployments.

Expected result: identify one verified previous image digest that was successfully deployed to production.

### 3. Roll back through the approved workflow

Use the **Rollback Production** workflow with the verified previous image digest.

```bash
gh workflow list
```

Meaning: confirms the available workflow name.

```bash
gh workflow run "Rollback Production" -f IMAGE_DIGEST=PREVIOUS_DIGEST
```

Meaning: triggers the approved rollback workflow using the last known-good digest. Replace `PREVIOUS_DIGEST` with the exact digest identified from the last successful production deployment.

```bash
gh run list --workflow "Rollback Production" --limit 5
```

Meaning: confirms that the rollback workflow started.

```bash
gh run watch RUN_ID
```

Meaning: follows the rollback workflow until it completes.

### 4. Update production configuration

If the rollback requires an environment change, update `deploy/production.env` through a release PR.

```bash
git status
```

Meaning: confirms a clean working tree before creating a release change.

```bash
git switch -c rollback-production-env
```

Meaning: creates a dedicated branch for the rollback configuration change.

```bash
nano deploy/production.env
```

Meaning: updates only the required production environment value, such as the image digest or release identifier.

```bash
git diff
```

Meaning: reviews the exact configuration change before committing.

```bash
git add deploy/production.env
git commit -m "fix(production): roll back to previous image digest"
git push origin rollback-production-env
```

Meaning: pushes the rollback branch for review and the release PR process.

```bash
gh pr create --base main --head rollback-production-env \
  --title "Roll back production to previous image digest" \
  --body "Rolls back production after a failed deployment. Uses the last known-good image digest and preserves incident evidence."
```

Meaning: creates the release PR for review and approval.

### 5. Verify recovery

```bash
curl -I --max-time 10 "http://${EC2_PUBLIC_IP}:80"
```

Meaning: confirms that production is responding again.

```bash
ssmrun "docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"
```

Meaning: confirms that the production containers are running after rollback.

```bash
ssmrun "docker logs --tail 100 terraform-aws-infra-nginx"
```

Meaning: checks that Nginx is no longer reporting upstream errors.

```bash
ssmrun "docker logs --tail 100 PRODUCTION_API_CONTAINER_NAME"
```

Meaning: confirms that the rolled-back API is healthy.

```bash
aws cloudwatch describe-alarms \
  --query 'MetricAlarms[].{AlarmName:AlarmName,State:StateValue,Reason:StateReason}' \
  --output table
```

Meaning: verifies whether alarms are returning to `OK`.

## When NOT to Roll Back

Do not roll back immediately when:

- The failure is clearly caused by an external dependency, such as RDS, DNS, a third-party API, or an expired secret.
- The new release did not cause the incident and rolling back would remove an important security or data fix.
- The previous image digest is unknown, unverified, or incompatible with the current database migration state.
- Rolling back would lose required data or reverse a necessary database migration.
- The incident is caused by infrastructure configuration, such as a security group, IAM role, or CloudWatch alarm configuration.
- The application is partially healthy and a targeted fix is safer than a full rollback.

In these cases, stabilize the incident, collect evidence, and choose either a targeted fix or a reviewed forward fix.

## Communication Template

```text
Incident: Production deployment caused an application failure.
Impact: Production users are experiencing errors or unavailability.
Action: Rolling back to the last known-good image digest through the approved Rollback Production workflow.
Status: Rollback in progress.
Next update: Will confirm recovery after health checks and CloudWatch alarms are verified.
```

## 30-Second Interview Answer

“When a deployment breaks production, I first confirm the impact and check whether the failure began immediately after the release. If a verified previous image digest exists, I use the Rollback Production workflow to restore the last known-good version. If the rollback needs an environment change, I update `deploy/production.env` through a release PR. I verify recovery with HTTP checks, container logs, and CloudWatch alarms, then investigate the root cause before deploying again.”
