# Day 106 — 3-Tier Architecture Concepts
## What We Are Studying
3-tier architecture separates applications into web (presentation), application (business logic), and database (data) layers. Each tier runs in its own network segment with controlled access. This improves security, scalability, and maintainability.
## Commands Used
| Command | Purpose |
|---------|---------|
| `docker network create <tier-network>` | Create isolated network per tier |
| `docker run --network <web-tier> -p 80:80 <web-image>` | Deploy web tier |
| `docker run --network <app-tier> <app-image>` | Deploy app tier |
