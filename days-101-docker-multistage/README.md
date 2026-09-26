# Day 101 — Docker Multi-Stage Builds
## What We Are Studying
Multi-stage builds use multiple FROM statements in one Dockerfile. Each stage starts fresh, letting you copy only needed artifacts to the final image. This produces smaller, more secure production images.
## Commands Used
| Command | Purpose |
|---------|---------|
| `docker build --target <stage> -t <name> .` | Build specific stage |
| `docker images` | List images with sizes |
| `docker run --rm <image>` | Run container |
