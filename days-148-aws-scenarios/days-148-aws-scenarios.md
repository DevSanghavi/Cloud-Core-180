# Day 148/180 — Phase 7, Day 3: AWS Scenarios

## Scenario 1 — Security Group blocks SSH

### Symptom
An SSH connection times out, even though the EC2 instance appears running and its public IP is reachable.

### Likely causes
1. The security group does not allow inbound TCP port 22 from the client IP.
2. The client’s public IP changed, so an old allow rule no longer matches.
3. The instance is in a private subnet without an internet route.
4. The instance has no public IP or Elastic IP.
5. A network ACL or route table issue prevents traffic from reaching the subnet.

### Triage
Run from `~/cloud-practice/devops-monitoring-suite` after `source .env`.

```bash
curl -4 ifconfig.me
```

Meaning: shows the current public IP of the workstation. Compare it with the security-group SSH source range.

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
  --query 'SecurityGroups[].IpPermissions[?FromPort==`22`]' \
  --output json
```

Meaning: shows the inbound rules that allow TCP port 22. Replace `SG_ID` with the security-group ID shown by the instance description.

```bash
nc -vz "$EC2_PUBLIC_IP" 22
```

Meaning: tests whether TCP port 22 is reachable. A timeout usually indicates a network or security-group issue; a refusal usually indicates that the service is not listening.

```bash
aws ec2 describe-route-tables \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --query 'RouteTables[].Routes[].{Destination:DestinationCidrBlock,GatewayId:GatewayId,NatGatewayId:NatGatewayId}' \
  --output table
```

Meaning: confirms whether the subnet has a route to an internet gateway. Replace `VPC_ID` with the VPC ID from the instance description.

### Fix
1. Confirm the workstation’s current public IP.
2. Update the security-group inbound rule to allow TCP port 22 only from the current approved IP or CIDR range.
3. Avoid opening port 22 to `0.0.0.0/0`; prefer a narrow, current IP range.
4. If SSH is not required, use AWS Systems Manager Session Manager instead.
5. If the instance has no public IP, use SSM rather than adding an unnecessary public IP.
6. After changing access, test with `nc -vz` and then connect through the approved method.

### Prevention
- Use SSM for routine EC2 access instead of broad SSH access.
- Keep SSH rules restricted to a known IP range.
- Document the approved bastion or access path.
- Review security-group rules during infrastructure changes.

### Real incident
My SSH connection timed out after my home IP changed and I no longer had the correct key available. I used SSM instead, but the SSM agent was offline until the instance role was attached. This taught me that an SSH timeout can be a security-group issue, while an SSM failure can be an IAM or instance-role issue.

### 30-second interview answer
“When SSH times out, I first confirm my current public IP and compare it with the EC2 security group’s inbound rule for TCP port 22. I check the instance state, public IP, subnet, and route table. If SSH is not required, I prefer SSM Session Manager. I avoid opening port 22 to the entire internet and keep access limited to approved IP ranges.”

## Scenario 2 — RDS connection timeout

### Symptom
The application cannot connect to RDS, database queries hang, or the connection attempt times out.

### Likely causes
1. The RDS security group does not allow inbound MySQL port 3306 from the application security group.
2. The RDS instance is not publicly accessible and the application is trying to connect from outside the VPC.
3. The database hostname, port, username, password, or database name is incorrect.
4. The RDS instance is stopped, unavailable, or still starting.
5. The application is using the wrong VPC, subnet, or DNS resolution path.

### Triage
Run from `~/cloud-practice/devops-monitoring-suite` after `source .env`.

```bash
aws rds describe-db-instances \
  --query 'DBInstances[].{DBInstanceIdentifier:DBInstanceIdentifier,DBInstanceStatus:DBInstanceStatus,Engine:Engine,Endpoint:Endpoint.Address,Port:Endpoint.Port,PubliclyAccessible:PubliclyAccessible,VpcSecurityGroups:VpcSecurityGroups,SubnetGroup:DBSubnetGroup}' \
  --output table
```

Meaning: confirms the RDS status, endpoint, port, public accessibility, security groups, and subnet group.

```bash
aws ec2 describe-security-groups \
  --group-ids "$RDS_SG_ID" \
  --query 'SecurityGroups[].IpPermissions' \
  --output json
```

Meaning: shows whether inbound TCP port 3306 is allowed from the application security group.

```bash
nc -vz "$RDS_ENDPOINT" 3306
```

Meaning: tests TCP reachability to the RDS endpoint. A timeout points to networking or security-group configuration; a refusal points to the database service or listener.

```bash
dig +short "$RDS_ENDPOINT"
```

Meaning: confirms that the RDS hostname resolves to a private IP address.

```bash
ssmrun "nc -vz $RDS_ENDPOINT 3306"
```

Meaning: tests connectivity from the EC2 instance, which is the correct network location for a private RDS database.

```bash
ssmrun "docker logs --tail 100 APPLICATION_CONTAINER_NAME"
```

Meaning: shows the application’s database connection error and confirms whether it is a timeout, authentication failure, or DNS failure.

### Fix
1. Confirm that the application connects from within the same VPC as RDS.
2. Add an inbound rule to the RDS security group allowing TCP port 3306 only from the application security group.
3. Do not allow port 3306 from `0.0.0.0/0`.
4. Verify that the RDS endpoint, port, database name, username, and password secret are correct.
5. If RDS is starting or stopped, wait for it to become available before changing network configuration.
6. Retest from the EC2 instance using `nc -vz` and then verify the application health endpoint.

### Prevention
- Use security-group references rather than broad CIDR ranges for RDS access.
- Keep RDS in private subnets.
- Store database credentials in AWS Secrets Manager.
- Add database connectivity checks to deployment validation.

### Real incident
When creating my RDS subnet group, I learned that it required subnets in at least two Availability Zones. This reinforced that RDS networking is not only about a security group; subnet placement and Availability Zone coverage also matter.

### 30-second interview answer
“For an RDS connection timeout, I first determine whether it is a network or authentication issue. I check the RDS endpoint, port, status, and security-group inbound rule for TCP 3306. Then I test connectivity from the application’s EC2 instance, because RDS is private and should be reached from within the VPC. If TCP connects but login fails, I investigate credentials and Secrets Manager rather than changing security groups.”

## Scenario 3 — IAM access denied

### Symptom
An AWS CLI command, EC2 instance role, Lambda function, or CI/CD workflow fails with `AccessDenied`, `UnauthorizedOperation`, or `not authorized to perform`.

### Likely causes
1. The IAM identity lacks the required allow permission.
2. An explicit `Deny` policy overrides an allow permission.
3. The resource-based policy, such as an S3 bucket policy or KMS key policy, blocks access.
4. The request uses the wrong AWS region, account, or resource ARN.
5. The EC2 instance profile or GitHub Actions role is missing or not attached.

### Triage
Run from `~/cloud-practice/devops-monitoring-suite` after `source .env`.

```bash
aws sts get-caller-identity
```

Meaning: confirms the current AWS identity, account, and ARN making the request.

```bash
aws configure list
```

Meaning: shows the active AWS profile, region, and credential source.

```bash
aws iam list-attached-role-policies --role-name "$IAM_ROLE_NAME" --output table
```

Meaning: lists managed policies attached to the IAM role.

```bash
aws iam list-role-policies --role-name "$IAM_ROLE_NAME" --output table
```

Meaning: lists inline policies attached directly to the IAM role.

```bash
aws iam get-role --role-name "$IAM_ROLE_NAME" \
  --query 'Role.AssumeRolePolicyDocument' \
  --output json
```

Meaning: shows which trusted identities or services can assume the role.

```bash
aws s3api get-bucket-policy --bucket "$S3_BUCKET_NAME" --output json
```

Meaning: shows the S3 bucket policy, if one exists, and whether it explicitly allows or denies access.

```bash
ssmrun "curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/"
```

Meaning: shows the instance profile role available to the EC2 instance through the instance metadata service.

### Fix
1. Identify the exact denied action, resource ARN, and requesting identity from the error message.
2. Confirm the active AWS profile, region, and identity with `aws sts get-caller-identity`.
3. Add only the minimum required IAM permissions; do not grant broad administrator access.
4. Check for explicit `Deny` statements in identity policies, permissions boundaries, SCPs, and resource policies.
5. If using an EC2 role, ensure the instance profile is attached and the application uses the instance role rather than long-lived keys.
6. Retry the exact failed action after the policy change and verify that only the intended access works.

### Prevention
- Apply least privilege.
- Use IAM roles for EC2 and CI/CD instead of static access keys.
- Test permissions with the smallest possible policy before deployment.
- Log and review denied actions in CloudTrail when investigating recurring access issues.

### Real incident
My EC2 `awslogs` containers initially had empty log paths because the EC2 instance did not have the required IAM role attached. After attaching the instance role, the CloudWatch Logs driver could authenticate and write logs. This taught me that an IAM access-denied issue can appear as an application or logging failure rather than an obvious AWS CLI error.

### 30-second interview answer
“When IAM access is denied, I first identify the exact caller with `aws sts get-caller-identity`, then read the error for the denied action and resource ARN. I check the identity’s attached and inline policies, look for explicit Deny rules, and verify resource policies such as S3 bucket policies. For EC2, I confirm that the instance profile role is attached. I fix the permission with least privilege and retest only the specific action.”

## Interview Rule

For AWS incidents, identify the failure layer before changing anything: **network reachability, service configuration, or IAM authorization.** Security groups control network access, RDS configuration controls database availability, and IAM policies control what an identity is allowed to do.
