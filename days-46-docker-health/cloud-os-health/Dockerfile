FROM python:3.11-slim AS builder
WORKDIR /app
COPY healthcheck.py .

FROM python:3.11-alpine
WORKDIR /app
COPY --from=builder /app/healthcheck.py .
ENV HEALTH_STATUS=ok 
CMD ["python", "healthcheck.py"]
