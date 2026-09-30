# Day 105 — Docker Production Hardening
## What We Are Studying
Running containers as non-root reduces security risk if the container is compromised. Read-only root filesystem prevents attackers from modifying binaries or installing malware. These are critical security best practices for production.
## Commands Used
| Command | Purpose |
|---------|---------|
| `docker run --user <uid>:<gid> <image>` | Run container as non-root |
| `docker run --read-only <image>` | Make root filesystem read-only |
| `docker run --tmpfs /tmp <image>` | Mount tmpfs volume for writes |
