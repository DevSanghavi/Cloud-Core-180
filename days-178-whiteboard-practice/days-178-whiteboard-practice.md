# Day 178 — Buffer: Whiteboard practice—draw a 3-tier app from memory

## Goal

Draw a three-tier application architecture from memory, explain each layer and request flow, and map it to the actual P1-P3 environment.

## Three-Tier Architecture

```text
+---------------------+
|      User           |
|  Browser / Client   |
+----------+----------+
           |
           | HTTPS / HTTP
           v
+---------------------+
| Presentation Layer  |
| Nginx Reverse Proxy |
| Port 80             |
+----------+----------+
           |
           | Internal HTTP
           v
+---------------------+
| Application Layer   |
| Flask / Node.js API |
| Docker Containers   |
+----------+----------+
           |
           | Private network
           v
+---------------------+
| Data Layer          |
| RDS MySQL Database  |
| Private Subnets     |
+---------------------+
```

## Layer Explanations

| Layer | Purpose | Example in projects |
|---|---|---|
| Presentation layer | Receives user traffic and forwards it to the application | Nginx reverse proxy on EC2 port 80 |
| Application layer | Runs business logic and serves API requests | Flask container in P1 and Node.js API containers in P2 |
| Data layer | Stores and retrieves application data | Private RDS MySQL database in P1 |

## Request Flow

1. A user sends a request to the EC2 public IP on port 80.
2. The EC2 security group allows inbound traffic on port 80.
3. Nginx receives the request and acts as the reverse proxy.
4. Nginx forwards the request to the application container over the internal network.
5. The application processes the request and queries the private RDS MySQL database when needed.
6. The application returns a response to Nginx.
7. Nginx returns the response to the user.

## Mapping to Projects

```text
User
  |
  v
Nginx reverse proxy (P1, port 80)
  |
  v
Flask application container (P1)
  |
  v
Private RDS MySQL database (P1)

P2 production API
  |
  v
Nginx reverse proxy (P1, port 80)
  |
  v
project2-production-api container (P2)

P2 staging API
  |
  v
project2-staging-api container (P2, host port 8080)
```

## Security Boundaries

| Boundary | Control |
|---|---|
| Internet to EC2 | Security group allows inbound port 80 only as required |
| EC2 to RDS | Security group allows MySQL traffic only from the application resources |
| RDS to internet | RDS remains in private subnets and is not directly reachable from the internet |
| EC2 administration | AWS SSM is used instead of relying on SSH from a changing home IP |

## Whiteboard Practice Method

1. Draw the user, presentation, application, and data layers.
2. Draw arrows showing the request path.
3. Label ports, security boundaries, and private subnets.
4. Explain the flow aloud without looking at the diagram.
5. Draw the P1 and P2 mapping from memory.
6. Identify one improvement for scalability or reliability.

## Scalability Improvements

| Improvement | Purpose |
|---|---|
| Add an Application Load Balancer | Distribute traffic across multiple application instances |
| Run multiple EC2 instances | Reduce single-instance dependency |
| Use Auto Scaling | Add capacity based on demand |
| Use a managed database with Multi-AZ | Improve database availability |
| Add centralized logging | Make troubleshooting easier across instances |
| Add automated backups and restore testing | Improve recovery readiness |

## Common Interview Questions

1. What are the three tiers in a three-tier application?
2. Why place the database in private subnets?
3. What is the role of a reverse proxy?
4. How does traffic reach the application from the internet?
5. How would you scale this architecture?
6. What happens if the application instance fails?
7. How would you secure communication between tiers?

## Practice Checklist

| Item | Can draw from memory | Can explain aloud |
|---|---|---|
| User layer | Yes/No | Yes/No |
| Presentation layer | Yes/No | Yes/No |
| Application layer | Yes/No | Yes/No |
| Data layer | Yes/No | Yes/No |
| Request flow | Yes/No | Yes/No |
| Security boundaries | Yes/No | Yes/No |
| P1 mapping | Yes/No | Yes/No |
| P2 mapping | Yes/No | Yes/No |
| Scalability improvements | Yes/No | Yes/No |

## Rules Followed

- No AWS create, modify, delete, terminate, or destroy command was used.
- P1, P2, and P3 repositories and running resources remain untouched.
- All architecture explanations use only completed project work and verified facts.
- No experience, employers, metrics, salaries, or company names were invented.
