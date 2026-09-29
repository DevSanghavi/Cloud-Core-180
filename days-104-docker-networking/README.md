# Day 104 — Docker Networking Review
## What We Are Studying
Custom bridge networks let containers communicate using DNS names instead of IP addresses. Port mapping exposes container services to the host. Network isolation improves security and organization.
## Commands Used
| Command | Purpose |
|---------|---------|
| `docker network create <network-name>` | Create custom bridge network |
| `docker run --network <network-name> --name <container-name> <image>` | Attach container to network |
| `docker run -p <host-port>:<container-port> <image>` | Publish port |
