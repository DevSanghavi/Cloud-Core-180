# Day 153/180 — Phase 7, Day 8: Database Scenarios

## Scenario 1 — Too many connections

### Symptom
The application reports errors such as `Too many connections`, `Connection refused`, or `too many clients already`. New requests fail while existing requests may still work.

### Likely causes
1. The application opens a new database connection for every request instead of using a connection pool.
2. A deployment increased the number of application instances or workers without reviewing database capacity.
3. Connections were not closed properly after an error or timeout.
4. A long-running query holds a connection for too long.
5. The RDS instance has a low connection limit for its instance class.

### Triage
Run from `~/cloud-practice/devops-monitoring-suite` after `source .env`.

```bash
aws rds describe-db-instances \
  --query 'DBInstances[].{DBInstanceIdentifier:DBInstanceIdentifier,DBInstanceStatus:DBInstanceStatus,Engine:Engine,Endpoint:Endpoint.Address,Port:Endpoint.Port,AllocatedStorage:AllocatedStorage,DBInstanceClass:DBInstanceClass}' \
  --output table
```

Meaning: confirms the RDS instance status, endpoint, port, storage, and instance class.

```bash
aws cloudwatch get-metric-statistics \
  --namespace AWS/RDS \
  --metric-name DatabaseConnections \
  --dimensions Name=DBInstanceIdentifier,Value="$RDS_INSTANCE_ID" \
  --start-time "$(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%SZ)" \
  --end-time "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  --period 300 \
  --statistics Maximum \
  --output table
```

Meaning: shows the maximum number of database connections over the last hour.

```bash
ssmrun "docker logs --tail 200 APPLICATION_CONTAINER_NAME"
```

Meaning: shows whether the application is reporting connection-pool exhaustion, timeouts, or authentication failures.

```bash
ssmrun "docker stats --no-stream"
```

Meaning: checks whether application containers are consuming excessive CPU or memory while handling requests.

```bash
ssmrun "curl -I http://127.0.0.1:80"
```

Meaning: confirms whether Nginx and the production path are still responding.

```bash
ssmrun "curl -I http://127.0.0.1:8080"
```

Meaning: confirms whether the staging API is still responding.

### Fix
1. Confirm whether the error is a connection limit, timeout, or authentication issue by reading application logs.
2. Check the RDS connection metric and compare it with the instance class limit.
3. Configure a bounded connection pool in the application rather than opening unlimited connections.
4. Reduce the number of application workers or instances only after confirming they are creating excess connections.
5. Investigate long-running queries and add appropriate timeouts.
6. If the workload legitimately needs more capacity, plan an RDS instance-class change through the approved infrastructure process.
7. Restart an application container only after identifying the cause; do not restart it as a default response.

### Prevention
- Use a connection pool with a fixed maximum size.
- Set database connection, idle, and query timeouts.
- Load-test expected traffic before deployment.
- Monitor `DatabaseConnections` in CloudWatch.
- Keep database credentials and configuration outside source code.

### Real incident
My RDS subnet group required subnets in at least two Availability Zones. This taught me that database availability depends on more than application configuration; networking, subnet placement, and instance capacity must also be designed correctly.

### 30-second interview answer
“When an application reports too many database connections, I first read the application logs to distinguish connection exhaustion from a timeout or authentication error. I check the RDS `DatabaseConnections` CloudWatch metric and compare it with the instance limit. Then I review the application’s connection pool, worker count, and long-running queries. I fix the connection lifecycle and pooling configuration before considering a larger database instance.”

## Scenario 2 — Slow query symptoms

### Symptom
API responses become slow, database CPU rises, requests queue behind the database, or users report timeouts during normal traffic.

### Likely causes
1. A query scans more rows than necessary because of a missing or unused index.
2. A query returns too much data, such as an unbounded list or large join.
3. A long-running transaction holds locks and blocks other queries.
4. The database instance is CPU, memory, or I/O constrained.
5. A recent deployment introduced an inefficient query or increased traffic.

### Triage
Run from `~/cloud-practice/devops-monitoring-suite` after `source .env`.

```bash
aws cloudwatch get-metric-statistics \
  --namespace AWS/RDS \
  --metric-name CPUUtilization \
  --dimensions Name=DBInstanceIdentifier,Value="$RDS_INSTANCE_ID" \
  --start-time "$(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%SZ)" \
  --end-time "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  --period 300 \
  --statistics Average,Maximum \
  --output table
```

Meaning: shows whether RDS CPU usage increased during the slowdown.

```bash
aws cloudwatch get-metric-statistics \
  --namespace AWS/RDS \
  --metric-name DatabaseConnections \
  --dimensions Name=DBInstanceIdentifier,Value="$RDS_INSTANCE_ID" \
  --start-time "$(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%SZ)" \
  --end-time "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  --period 300 \
  --statistics Maximum \
  --output table
```

Meaning: shows whether connection growth correlates with the slowdown.

```bash
aws cloudwatch get-metric-statistics \
  --namespace AWS/RDS \
  --metric-name FreeableMemory \
  --dimensions Name=DBInstanceIdentifier,Value="$RDS_INSTANCE_ID" \
  --start-time "$(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%SZ)" \
  --end-time "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  --period 300 \
  --statistics Minimum,Average \
  --output table
```

Meaning: shows whether available database memory decreased during the incident.

```bash
ssmrun "docker logs --tail 200 APPLICATION_CONTAINER_NAME"
```

Meaning: identifies slow requests, database timeout errors, or queries that began failing after a deployment.

```bash
ssmrun "docker stats --no-stream"
```

Meaning: checks whether the application container is consuming excessive resources.

```bash
ssmrun "curl -I http://127.0.0.1:80"
```

Meaning: verifies whether Nginx is still responding.

```bash
ssmrun "curl -I http://127.0.0.1:8080"
```

Meaning: verifies whether the staging API is still responding.

### Fix
1. Correlate the slowdown with a deployment, traffic increase, or specific endpoint.
2. Identify the slow query from application logs, database logs, or query-performance tooling.
3. Review the query plan and add or improve an index only after confirming the access pattern.
4. Limit result sizes with pagination and avoid returning unnecessary columns.
5. Reduce transaction duration and ensure connections are returned to the pool.
6. If RDS CPU, memory, or I/O is consistently constrained, plan a capacity change through the approved infrastructure process.
7. Verify recovery using response time, error rate, database metrics, and application logs.

### Prevention
- Add indexes based on real query patterns.
- Use pagination for large result sets.
- Monitor RDS CPU, memory, connections, and I/O.
- Review query performance before production deployment.
- Keep application and database versions compatible.

### Real incident
My CloudWatch disk alarm initially remained in `INSUFFICIENT_DATA` because the alarm’s metric dimensions did not match the actual disk metric. This taught me to validate that the monitoring metric is correctly configured before using it to diagnose a performance issue.

### 30-second interview answer
“When queries become slow, I correlate the timing with deployments, traffic, and RDS metrics such as CPU, memory, connections, and I/O. I inspect application logs to identify the affected endpoint or query, then review the query plan and indexes. I avoid adding an index blindly; I first confirm the query pattern and whether the database is actually constrained.”

## Interview Rule

For database incidents, distinguish **connection exhaustion** from **query performance**: too many connections is usually a connection-lifecycle or capacity issue, while slow queries are usually a query, index, locking, or resource-capacity issue.
