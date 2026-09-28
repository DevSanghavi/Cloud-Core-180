# Day 103 — Docker Image Scanning with Trivy
## What We Are Studying
Trivy scans container images for known vulnerabilities in OS packages and application dependencies. It checks against CVE databases and reports severity levels. This is critical for security before deploying to production.
## Commands Used
| Command | Purpose |
|---------|---------|
| `trivy image <image-name>` | Scan Docker image |
| `trivy image --severity HIGH,CRITICAL <image-name>` | Filter by severity |
| `trivy image --format table <image-name>` | Output as table |
