# Day 102 — Docker Healthchecks
## What We Are Studying
HEALTHCHECK tells Docker how to test if your app is actually working, not just running. Docker runs the check command periodically and marks container healthy or unhealthy. Orchestrators use this for auto-healing and load balancer decisions.
## Commands Used
| Command | Purpose |
|---------|---------|
| `docker run --health-cmd "cmd" --health-interval 30s --health-timeout 3s --health-retries 3 <image>` | Add health check to container |
| `docker inspect --format "{{.State.Health.Status}}" <container>` | Check health status |
| `HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD curl -f http://localhost/ || exit 1` | Dockerfile health instruction |
