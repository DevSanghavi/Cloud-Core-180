# Day 99 — Rollback Strategies

## What We Are Studying

This lesson deploys a Docker image using a release tag.
If the release fails, Docker Compose is redeployed with the previous known-good tag.

## Commands Used

| Command | Purpose |
|---------|---------|
| `docker pull` | Downloads an image tag |
| `docker image inspect` | Confirms an image exists |
| `docker compose up -d` | Deploys the service |
| `docker compose ps` | Verifies service state |
| `docker compose logs` | Checks application output |
| `docker compose down` | Stops the failed deployment |
