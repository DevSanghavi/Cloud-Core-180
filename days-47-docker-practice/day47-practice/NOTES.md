# Day 47 Practice Verification Logs

1. Custom Network: `docker network create day47-practice-net`
2. Build Practice: `docker build -t dev-day47-practice:0.1.0 .`
3. Static Port (-p): `docker run -d --name practice-api-v1 -p 8082:8080 -e ENV=prod dev-day47-practice:0.1.0`
4. Dynamic Port (-P): `docker run -d --name practice-api-v2 -P dev-day47-practice:0.1.0`
