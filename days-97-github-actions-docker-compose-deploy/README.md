# Day 97 — GitHub Actions Docker Compose Deploy
## What We Are Studying
Deploy containerized apps to EC2 by having GitHub Actions SSH in, pull the latest Docker image from GHCR, and restart services using Docker Compose. This is a common pattern for simple microservice deployments.
## Commands Used
| Command | Purpose |
|---------|---------|
| `docker compose pull && docker compose up -d` | Pull new image and restart containers |
| `docker image prune -f` | Remove old unused images |
| `systemctl status docker` | Verify Docker daemon running |
| `uses appleboy/ssh-action@v1.2.0` | Execute deploy commands over SSH |

