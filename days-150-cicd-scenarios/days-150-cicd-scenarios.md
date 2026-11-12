# Day 150/180 — Phase 7, Day 5: CI/CD Scenarios

## Scenario 1 — Pipeline fails on test step

### Symptom
A GitHub Actions workflow reaches the test job or step and fails, preventing the image build, deployment, or merge.

### Likely causes
1. A unit or integration test failed because of an application bug.
2. A required test dependency, database, environment variable, or secret is missing.
3. The test command hangs because it waits for a service that never becomes ready.
4. The test environment uses a different Node, Python, or dependency version from local development.
5. A flaky test fails intermittently because of timing, network, or shared-state issues.

### Triage
Run from the affected project repository.

```bash
git status
```

Meaning: confirms that the working tree is clean and shows the current branch before investigating the pipeline.

```bash
git log --oneline -n 10
```

Meaning: identifies the commit that triggered the failed workflow.

```bash
gh run list --limit 10
```

Meaning: lists recent GitHub Actions runs, their status, workflow names, and branches.

```bash
gh run view RUN_ID --log-failed
```

Meaning: shows only the failed step logs, which is faster than reading the entire workflow log.

```bash
gh run view RUN_ID --job JOB_ID --log
```

Meaning: shows the full log for a specific job when the failed-step summary is not enough.

```bash
npm ci
npm test
```

Meaning: reproduces the test environment locally using the lockfile and runs the same test command used by CI.

### Fix
1. Open the failed step log and identify the first meaningful error, not only the final failure message.
2. Determine whether the failure is deterministic or flaky by rerunning the workflow only after understanding the cause.
3. If a dependency is missing, update `package.json`, `package-lock.json`, or the workflow setup step.
4. If a secret or environment variable is missing, add it through the approved GitHub Actions secrets process.
5. If a service is unavailable, add a readiness wait or health check before tests that depend on it.
6. Fix the application or test, commit the change, and allow CI to validate it before merging.
7. Do not disable a failing test just to make the pipeline pass.

### Prevention
- Keep dependency lockfiles committed.
- Use the same runtime version locally and in CI.
- Make tests independent and deterministic.
- Add health checks before integration tests.
- Fail fast with clear error messages.

### Real incident
In one of my Node.js projects, `npm test` hung because the test command waited indefinitely instead of completing. I also encountered a `better-sqlite3` compatibility issue because the application required Node 22 while the container image used Node 18. These incidents taught me to compare the CI runtime, lockfile, application requirements, and test command before changing code.

### 30-second interview answer
“When a pipeline fails on tests, I open the failed-step logs first and identify the earliest real error. I check whether the failure is caused by code, a missing dependency or secret, an environment-version mismatch, or a service that is not ready. I reproduce the issue locally with the same commands, fix the root cause, and never disable a test just to make the workflow green.”

## Scenario 2 — Secret expired

### Symptom
A workflow fails with an authentication, authorization, token-expired, or permission-denied error when accessing GitHub Container Registry, AWS, or another external service.

### Likely causes
1. A GitHub personal access token or fine-grained token expired.
2. An AWS access key was rotated, disabled, or deleted.
3. The GitHub Actions secret name is misspelled or missing.
4. The token or role lacks permission for the required action.
5. The workflow references a secret that was never configured in the repository or environment.

### Triage
Run from the affected project repository.

```bash
gh run list --limit 10
```

Meaning: identifies the failed workflow run and its status.

```bash
gh run view RUN_ID --log-failed
```

Meaning: shows the failed authentication or authorization error.

```bash
gh secret list
```

Meaning: lists repository secrets available to GitHub Actions. It does not display secret values.

```bash
gh workflow list
```

Meaning: confirms the workflow name and helps locate the correct workflow file.

```bash
git grep -n "secrets\."
```

Meaning: finds every GitHub Actions secret referenced in workflow files.

```bash
gh auth status
```

Meaning: checks the local GitHub CLI authentication status; it does not validate a repository Actions secret.

### Fix
1. Read the failed log and identify the exact service, action, and permission that failed.
2. Confirm that the secret name in the workflow exactly matches the secret configured in GitHub.
3. Create or rotate the expired credential through the approved secret-management process.
4. Grant only the minimum required permissions, such as package read or write access for GHCR.
5. Re-run the workflow after updating the secret or permission.
6. Verify that the next workflow run can authenticate and complete the affected step.

### Prevention
- Use short-lived OpenID Connect roles where supported instead of long-lived static credentials.
- Track secret expiration dates.
- Use descriptive secret names and document their purpose.
- Validate secrets and permissions in a staging workflow before production deployment.
- Never print secret values in workflow logs.

### Real incident
A new repository once failed because it had no required secrets configured. The deployment workflow could not access what it needed, even though the workflow file itself was present. This taught me to verify both the workflow configuration and the repository secrets before assuming the pipeline code is wrong.

### 30-second interview answer
“When a workflow fails because a secret expired, I read the failed-step log to identify the exact service and permission error. I compare the secret name referenced in the workflow with the secrets configured in GitHub, rotate or recreate the credential, and grant only the minimum required permissions. Then I rerun the workflow and confirm that the affected step succeeds.”

## Scenario 3 — Runner offline

### Symptom
A GitHub Actions workflow remains queued, a self-hosted runner is marked offline, or jobs fail because no runner is available.

### Likely causes
1. The self-hosted runner process is stopped.
2. The runner host lost network connectivity.
3. The runner token or registration is invalid.
4. The runner does not have enough disk, memory, or CPU capacity.
5. GitHub-hosted runners are unavailable or the workflow has a runner-label mismatch.

### Triage
Run from the affected project repository.

```bash
gh run list --limit 10
```

Meaning: shows whether jobs are queued, in progress, or failed.

```bash
gh run view RUN_ID
```

Meaning: shows job status, runner information where available, and failed steps.

```bash
gh workflow list
```

Meaning: confirms the workflow and helps identify the workflow file to inspect.

```bash
git grep -n "runs-on"
```

Meaning: shows the runner label requested by each job, such as `ubuntu-latest` or a self-hosted runner label.

```bash
systemctl status actions.runner.* --no-pager
```

Meaning: checks the self-hosted runner service status on the runner host.

```bash
journalctl -u "actions.runner.*" -n 100 --no-pager
```

Meaning: shows runner service logs and startup or connection errors.

```bash
df -h
free -h
uptime
```

Meaning: checks disk, memory, and load on the runner host before restarting anything.

### Fix
1. Confirm whether the workflow uses a GitHub-hosted runner or a self-hosted runner label.
2. If using a self-hosted runner, check its service status and logs on the runner host.
3. Restore network connectivity or correct the runner registration if the service cannot connect.
4. Free disk space or investigate resource pressure only after identifying the cause.
5. Restart the runner service only after reviewing its logs and confirming that it is safe to do so.
6. If the runner label is wrong, update the workflow’s `runs-on` value to match an available runner.
7. Re-run the workflow after the runner is healthy and visible.

### Prevention
- Monitor runner disk, memory, and service health.
- Use clear runner labels that match workflow requirements.
- Keep runner software and dependencies updated.
- Avoid relying on a single self-hosted runner for critical workflows.
- Add alerts for prolonged queued jobs or runner downtime.

### Real incident
A deployment workflow once failed because Terraform was missing on the runner. Although this was not a runner-offline issue, it taught me the same lesson: a CI failure may be an environment or dependency problem on the runner, not a problem with the application code.

### 30-second interview answer
“When a runner is offline, I first check whether the workflow is queued and which runner label it requires. For a self-hosted runner, I inspect its service status and journal logs, then check disk, memory, and network connectivity. I fix the underlying runner issue, ensure the `runs-on` label matches an available runner, and only then rerun the workflow.”

## Interview Rule

For CI/CD incidents, isolate the failure layer: **application test failure, credential or secret failure, or runner availability failure.** Read the failed-step log first, reproduce the issue where possible, fix the root cause, and verify the next workflow run.
