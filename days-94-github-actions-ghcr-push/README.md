# Day 94 — GitHub Actions GHCR Push
## What We Are Studying
We authenticate to GitHub Container Registry (GHCR) inside GitHub Actions using `GITHUB_TOKEN`, build a Docker image, and push it to `ghcr.io/OWNER/REPO` tagged with the commit SHA. This gives free, versioned image storage tied to your repo.
## Commands Used
| Command | Purpose |
|---------|---------|
| `docker login ghcr.io -u USERNAME -p TOKEN` | Authenticate Docker to GHCR |
| `docker tag src dst` | Retag image for GHCR path |
| `docker push ghcr.io/OWNER/REPO:TAG` | Push image to GHCR |


