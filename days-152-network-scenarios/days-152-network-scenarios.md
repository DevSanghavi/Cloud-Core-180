# Day 152/180 — Phase 7, Day 7: Network Scenarios

## Scenario 1 — Connection refused

### Symptom
A client receives `Connection refused` when trying to reach an application, Nginx, API, or database port.

### Likely causes
1. The application or service is not running.
2. The service is listening on a different port than the client is using.
3. The service is listening only on localhost instead of all required interfaces.
4. A container is stopped, crashed, or was never started.
5. A firewall or security group is actively rejecting the connection rather than silently dropping it.

### Triage
Run from `~/cloud-practice/devops-monitoring-suite` after `source .env`.

```bash
docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
```

Meaning: confirms whether the expected container is running and which host ports it publishes.

```bash
docker port CONTAINER_NAME
```

Meaning: shows the container’s host-to-container port mapping.

```bash
docker logs --tail 100 CONTAINER_NAME
```

Meaning: shows whether the application failed to start, crashed, or is listening on an unexpected port.

```bash
ssmrun "docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"
```

Meaning: checks the actual container and port state on the EC2 host.

```bash
ssmrun "curl -I http://127.0.0.1:80"
```

Meaning: tests the production Nginx port locally on the EC2 instance.

```bash
ssmrun "curl -I http://127.0.0.1:8080"
```

Meaning: tests the staging API port locally on the EC2 instance.

```bash
curl -I "http://${EC2_PUBLIC_IP}:80"
```

Meaning: tests the public HTTP endpoint from the workstation.

```bash
nc -vz "$EC2_PUBLIC_IP" 80
```

Meaning: tests whether TCP port 80 is reachable. A `Connection refused` response means the host was reached, but nothing accepted the connection on that port.

### Fix
1. Start or restart the intended container only after reading its logs and identifying why it stopped.
2. Correct the application’s listening port or the Docker port mapping.
3. Ensure the application listens on the required interface, such as `0.0.0.0`, rather than only `127.0.0.1`.
4. If a security group is rejecting traffic, update the inbound rule through the approved infrastructure process.
5. Retest locally first, then externally, to confirm the service is healthy and reachable.

### Prevention
- Add container health checks.
- Use stable container names and documented port mappings.
- Validate application startup logs during deployment.
- Keep production and staging on separate ports.

### Real incident
My production Nginx container serves port 80 and proxies to the Project 2 production API, while staging runs on port 8080. Keeping these ports separate makes a refused connection easier to diagnose because I can immediately identify which service should be listening on which port.

### 30-second interview answer
“Connection refused means the client reached the host, but nothing accepted the connection on that port. I check whether the container is running, inspect its logs, verify its port mapping with `docker port`, and test the port locally with `curl` or `nc`. If the service is healthy locally but refuses externally, I investigate the security group or load-balancer configuration.”

## Scenario 2 — Connection timeout

### Symptom
A client waits and eventually receives a timeout, such as `Connection timed out`, while trying to reach an application, SSH port, or database.

### Likely causes
1. A security group does not allow the required inbound port.
2. A network ACL blocks the traffic.
3. The instance has no public IP, or the route table lacks an internet route.
4. The client is using the wrong IP address or DNS name.
5. A firewall silently drops packets before they reach the service.

### Triage
Run from `~/cloud-practice/devops-monitoring-suite` after `source .env`.

```bash
curl -4 ifconfig.me
```

Meaning: shows the current public IP of the workstation for comparison with security-group rules.

```bash
ping -c 3 "$EC2_PUBLIC_IP"
```

Meaning: checks basic IP reachability. A successful ping does not prove that a TCP service is reachable, but failure can indicate a broader network issue.

```bash
nc -vz -w 5 "$EC2_PUBLIC_IP" 80
```

Meaning: tests TCP port 80 with a five-second timeout. A timeout means the connection did not complete.

```bash
nc -vz -w 5 "$EC2_PUBLIC_IP" 22
```

Meaning: tests whether the SSH port is reachable.

```bash
aws ec2 describe-instances \
  --instance-ids "$EC2_INSTANCE_ID" \
  --query 'Reservations[].Instances[].{InstanceId:InstanceId,State:State.Name,PublicIp:PublicIpAddress,SubnetId:SubnetId,VpcId:VpcId,SecurityGroups:SecurityGroups}' \
  --output table
```

Meaning: confirms the instance state, public IP, subnet, VPC, and attached security groups.

```bash
aws ec2 describe-security-groups \
  --group-ids "$SG_ID" \
  --query 'SecurityGroups[].IpPermissions' \
  --output json
```

Meaning: shows the inbound rules and identifies whether the required port and source CIDR are allowed.

```bash
aws ec2 describe-route-tables \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --query 'RouteTables[].Routes[].{Destination:DestinationCidrBlock,GatewayId:GatewayId,NatGatewayId:NatGatewayId}' \
  --output table
```

Meaning: confirms whether the subnet has an internet route.

### Fix
1. Confirm the client’s current public IP and compare it with the security-group source range.
2. Add or correct the inbound rule for the required TCP port, using the narrowest appropriate source range.
3. Confirm that the instance has a public IP or is reachable through an approved load balancer or bastion.
4. Verify that the subnet route table has the required internet route.
5. If the service is internal, connect from an approved resource inside the VPC rather than exposing it publicly.
6. Retest with `nc -vz` and then validate the application endpoint with `curl`.

### Prevention
- Use SSM for routine EC2 access instead of broad SSH access.
- Keep security-group rules narrowly scoped.
- Document required inbound ports and approved source ranges.
- Validate network access after infrastructure changes.

### Real incident
My SSH connection timed out after my home IP changed and I no longer had the correct SSH key. I switched to SSM, but the SSM agent was offline until the EC2 instance role was attached. This taught me that a timeout can be caused by a security group, while an SSM failure can be caused by IAM or instance-role configuration.

### 30-second interview answer
“A connection timeout means packets are being dropped or filtered before the service can respond. I first confirm my public IP, test the port with `nc -vz`, and check the EC2 instance state, public IP, security-group inbound rules, and route table. I fix the narrowest possible security-group or routing issue, then retest both TCP connectivity and the application endpoint.”

## Scenario 3 — Refused versus timeout diagnosis

### Symptom
You need to explain whether a network problem is caused by a stopped service or by a security or routing block.

### Likely causes
1. The service is not listening, causing a refusal.
2. The service is listening, but a security group or network path blocks traffic, causing a timeout.
3. The client is using the wrong hostname or port.
4. DNS resolves incorrectly, sending traffic to the wrong destination.
5. The service is healthy locally but unavailable externally.

### Triage
Run from `~/cloud-practice/devops-monitoring-suite` after `source .env`.

```bash
docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
```

Meaning: confirms whether the expected service is running and publishing a port.

```bash
docker logs --tail 100 CONTAINER_NAME
```

Meaning: shows whether the application started successfully and which port it is listening on.

```bash
ssmrun "curl -I http://127.0.0.1:80"
```

Meaning: tests the service locally on the EC2 host.

```bash
nc -vz -w 5 "$EC2_PUBLIC_IP" 80
```

Meaning: tests the same port from outside the EC2 host.

```bash
dig +short "$EC2_PUBLIC_IP"
```

Meaning: performs a reverse DNS lookup for the public IP; use this only when DNS is part of the suspected issue.

```bash
nslookup "$EC2_PUBLIC_IP"
```

Meaning: provides an alternative reverse DNS check.

```bash
curl -I "http://${EC2_PUBLIC_IP}:80"
```

Meaning: validates the full public HTTP path from the workstation.

### Fix
1. If the local check succeeds but the external check times out, investigate security groups, route tables, or the public IP.
2. If both local and external checks fail, investigate the container, application logs, listening port, and service configuration.
3. If the connection is refused, start or correct the service before changing network rules.
4. If DNS is wrong, correct the DNS record or use the correct endpoint.
5. Verify the fix with both a TCP connectivity test and an application-level HTTP check.

### Prevention
- Test services locally before testing them externally.
- Keep a documented port map for production and staging.
- Use health checks that validate the actual application endpoint.
- Separate network failures from application failures during incident review.

### Real incident
My disk alarm initially showed `INSUFFICIENT_DATA` because its CloudWatch metric dimensions did not match the actual disk metric. Although this was a monitoring issue rather than a network issue, it taught me the same diagnostic principle: confirm that the evidence source is configured correctly before drawing a conclusion.

### 30-second interview answer
“I separate the network path from the service itself. A connection refused usually means the host was reached but no service accepted the port, so I check container status, logs, and port mappings. A timeout usually means traffic is blocked before reaching the service, so I check the security group, route table, public IP, and client source IP. I always validate locally first, then externally.”
