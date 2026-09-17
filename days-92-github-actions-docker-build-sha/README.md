# Day 92 — GitHub Actions Docker Build
## What We Are Studying
We build a Docker image in GitHub Actions on every push and tag it with the commit SHA. This gives immutable, traceable artifacts per commit without needing a registry.
## Commands Used
| Command | Purpose |
|---------|---------|
| `docker build -t name:tag .` | Build image from Dockerfile |
| `docker tag old new` | Retag image with SHA |
| `actions/upload-artifact@v4` | Upload tarball as CI artifact |
