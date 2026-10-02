# Day 107 — Load Balancing Concepts
## What We Are Studying
Load balancing distributes incoming traffic across multiple backend servers to prevent overload. It improves availability, scalability, and fault tolerance. If one backend fails, traffic routes to healthy ones.
## Commands Used
| Command | Purpose |
|---------|---------|
| `docker run -d --name lb --network app-network -p 80:80 nginx:alpine` | Deploy nginx as load balancer |
| `docker run -d --network app-network --name backend-1 nginx:alpine` | Deploy backend container |
| `docker exec lb cat /etc/nginx/nginx.conf` | View nginx config |
