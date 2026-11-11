# Day 147/180 — Phase 7, Day 2: Docker Scenarios

## Scenario 1 — Container exits immediately

### Symptom
A container starts and immediately stops, repeatedly restarts, or `docker ps` does not show it as running.

### Likely causes
1. The application crashed during startup.
2. A required environment variable, secret, or configuration file is missing.
3. The container command or entrypoint is incorrect.
4. A dependency, such as a database or upstream service, is unavailable.
5. The image was built for the wrong architecture or uses an incompatible runtime version.

### Triage
Run from `~/cloud-practice/devops-monitoring-suite` after `source .env`.

```bash
docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Image}}'
```

Meaning: shows both running and stopped containers. `Exited (0)` usually means a clean exit; a non-zero exit code usually means an error.

```bash
docker logs --tail 100 CONTAINER_NAME
```

Meaning: shows the container’s recent stdout and stderr. This is usually the fastest way to find the startup error.

```bash
docker inspect CONTAINER_NAME --format 'ExitCode={{.State.ExitCode}} Error={{.State.Error}} OOMKilled={{.State.OOMKilled}} RestartCount={{.RestartCount}}'
```

Meaning: confirms the exit code, runtime error, out-of-memory status, and restart count.

```bash
docker inspect CONTAINER_NAME --format '{{json .Config.Env}}' | tr ',' '\n'
```

Meaning: shows the environment variables passed to the container. Do not expose secret values in shared logs or screenshots.

```bash
docker inspect CONTAINER_NAME --format '{{json .Config.Cmd}} {{json .Config.Entrypoint}}'
```

Meaning: confirms the command and entrypoint Docker is using.

```bash
docker image inspect IMAGE_NAME --format '{{.Os}}/{{.Architecture}}'
```

Meaning: verifies that the image platform matches the EC2 instance architecture.

### Fix
1. Read the final lines of `docker logs` first; do not restart before identifying the failure.
2. Correct the missing environment variable, secret, configuration file, or command shown by the logs.
3. If the exit code is 137, investigate memory limits and the process that was killed; do not assume it was a normal shutdown.
4. If a dependency is unavailable, fix the dependency or make the application fail clearly with a useful startup error.
5. Rebuild or pull the correct image only after confirming the architecture and image tag.
6. Start the corrected container and verify it remains running with `docker ps`.

### Prevention
- Add a health check to critical containers.
- Fail fast with clear startup errors when required configuration is missing.
- Pin image tags and validate the target architecture in CI.
- Keep secrets in AWS Secrets Manager or GitHub Actions secrets, never hardcoded in images or Compose files.

### Real incident
In one of my Node.js deployments, the container failed because the application required Node 22 but the image used Node 18. The failure appeared as an application startup error rather than an obvious version mismatch. I learned to inspect the image version, application requirements, and container logs together before changing the deployment.

### 30-second interview answer
“When a container exits immediately, I first check `docker ps -a` for its exit status, then read `docker logs` for the actual error. I inspect the exit code, environment variables, command, and image architecture with `docker inspect`. I fix the specific startup cause—such as a missing secret, bad command, unavailable dependency, or incompatible Node version—before restarting.”

## Scenario 2 — Port already in use

### Symptom
A container fails to start with an error such as `address already in use`, or the application cannot bind to its intended host port.

### Likely causes
1. Another container is already publishing the same host port.
2. A host process, such as Nginx or a development server, is already listening on the port.
3. The Compose file or Docker run command maps the same host port twice.
4. The container is trying to bind a privileged port without appropriate configuration.
5. A previous container did not release the port cleanly.

### Triage
Run from `~/cloud-practice/devops-monitoring-suite` after `source .env`.

```bash
docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
```

Meaning: shows which containers are running and which host ports they publish.

```bash
docker port CONTAINER_NAME
```

Meaning: shows the container’s published host-to-container port mappings.

```bash
docker inspect CONTAINER_NAME --format '{{json .HostConfig.PortBindings}}'
```

Meaning: confirms the exact port bindings configured for the container.

```bash
ssmrun "docker ps --format 'table {{.Names}}\t{{.Ports}}'"
```

Meaning: checks all containers on the EC2 host through SSM.

```bash
ssmrun "curl -I http://127.0.0.1:80"
```

Meaning: verifies whether something is already responding on the production HTTP port.

```bash
ssmrun "curl -I http://127.0.0.1:8080"
```

Meaning: verifies whether the staging API port is already in use.

### Fix
1. Identify which container or host process already owns the port.
2. Change the new container’s host port mapping if both services must run simultaneously.
3. Stop only the conflicting container or service after confirming it is safe to stop.
4. Correct duplicate port mappings in the Compose file or deployment configuration.
5. Restart the affected container and verify the mapping with `docker port` and an HTTP request.

### Prevention
- Maintain a port allocation table for production, staging, and monitoring services.
- Use distinct host ports for production and staging.
- Validate Compose configuration before deployment.
- Avoid hardcoding ports in multiple places; define them once in configuration.

### Real incident
My production Nginx container serves port 80 and proxies to the Project 2 production API, while staging runs on port 8080. Keeping those ports separate prevented a conflict between production and staging. This taught me that port collisions are often configuration-design problems, not just runtime accidents.

### 30-second interview answer
“When a port is already in use, I first list running containers and their published ports with `docker ps`, then inspect the affected container’s port bindings. I determine whether another container or a host process owns the port, and I either use a different host port or safely stop the conflicting service. I verify the fix with `docker port` and a local HTTP request.”

## Scenario 3 — Image pull denied

### Symptom
A Docker pull, Compose deployment, or CI/CD deployment fails with `denied`, `unauthorized`, `authentication required`, or `manifest unknown`.

### Likely causes
1. The image name, tag, or registry URL is misspelled.
2. The image is private and the registry credentials are missing or expired.
3. The GitHub Container Registry token lacks the required package permissions.
4. The image was deleted, renamed, or the tag no longer exists.
5. The EC2 instance or CI runner cannot reach the registry because of network or DNS restrictions.

### Triage
Run from `~/cloud-practice/devops-monitoring-suite` after `source .env`.

```bash
docker pull IMAGE_NAME:TAG
```

Meaning: reproduces the pull error directly and shows the exact registry response.

```bash
docker images --format 'table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.CreatedSince}}'
```

Meaning: shows locally available images and helps identify whether the expected image already exists.

```bash
docker inspect IMAGE_NAME:TAG --format '{{json .RepoDigests}}'
```

Meaning: shows the image digest if the image is already present locally.

```bash
docker info --format '{{json .RegistryConfig}}'
```

Meaning: shows Docker registry configuration information available on the host.

```bash
docker logs --tail 100 CONTAINER_NAME
```

Meaning: confirms whether the failure occurred during an image pull or after the container started.

### Fix
1. Verify the exact image repository, tag, and registry hostname.
2. Confirm that the image exists in GitHub Container Registry and that the tag was published by the CI workflow.
3. Refresh or correct the registry credentials using the approved secret-management process.
4. Ensure the token or identity has permission to pull the required package.
5. If the image digest is known and available, use the previously deployed digest for a controlled rollback or recovery.
6. Retry the pull only after correcting the image reference or authentication issue.

### Prevention
- Use immutable image digests for production deployments where practical.
- Store registry credentials in GitHub Actions secrets or an EC2 instance role, not in source code.
- Verify that CI publishes the expected image tag before deployment.
- Keep a record of the last known-good image digest for rollback.

### Real incident
During a deployment workflow failure, I learned that a runner may not have Terraform installed and that a new repository may not have its required secrets configured. The same principle applies to Docker: before blaming the network or Docker itself, verify that the runner has the required credentials, permissions, and configuration.

### 30-second interview answer
“When an image pull is denied, I reproduce the exact error with `docker pull`, verify the image repository and tag, and check whether the registry credentials or token permissions are valid. I distinguish an authentication error from a missing tag or network issue. For production recovery, I use the last known-good image digest and update the deployment configuration through the approved release process.”

## Interview Rule

For every Docker incident, identify the exact failure boundary first: **container startup, host port binding, or registry image pull.** Then use the matching evidence: container logs and inspect data for startup, port mappings for conflicts, and registry authentication and image tags for pull failures.
