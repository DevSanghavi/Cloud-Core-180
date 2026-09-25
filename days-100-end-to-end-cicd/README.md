# Day 100 — End-to-End CI/CD Lab

## What We Are Studying

A GitHub Actions workflow builds a Docker image after a Git push.
The workflow tests the image, pushes it to GHCR, and deploys it with Docker Compose.

## Commands Used

| Command | Purpose |
|---------|---------|
| `git push` | Triggers the workflow |
| `docker build` | Builds the image |
| `docker run` | Tests the image |
| `docker compose up -d` | Deploys the service |
| `gh run list` | Checks workflow runs |

