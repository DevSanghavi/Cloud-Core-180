# Day 164 — AWS Cost Audit: Verify every EC2, RDS, and test resource is destroyed

## Goal

Audit all AWS resources that can generate cost, classify each as `EXPECTED RUNNING`, `EXPECTED RETAINED`, or `UNEXPECTED`, and record follow-up decisions without modifying or deleting any resource.

## Audit Rules

- Run every command from `~/cloud-practice/devops-monitoring-suite` after `source .env`.
- Use only read-only AWS CLI commands.
- Never run `terraform destroy`, `aws ec2 terminate-instances`, `aws rds delete-db-instance`, `aws s3 rb`, or any delete command.
- Keep the P1 EC2, P1 Flask container, P2 production and staging containers, RDS database, CloudWatch alarms, SNS topic, S3 backup bucket, and application dashboard running.
- Investigate any resource not required by P1, P2, or P3 before deciding whether to remove it later.

## Final Audit Checks

```bash
cd ~/cloud-practice/devops-monitoring-suite
source .env
```

### 1. Audit EC2 instances

```bash
aws ec2 describe-instances --profile "$PROFILE" --region "$REGION" --filters "Name=instance-state-name,Values=running,pending,stopping,stopped" --query 'Reservations[].Instances[].{InstanceId:InstanceId,Name:Tag[?Key==`Name`]|.Value,State:State.Name,Type:InstanceType,PublicIp:PublicIpAddress}' --output table
```

Expected: the P1 EC2 instance is `running`; no unknown running EC2 instances appear.

### 2. Audit EBS volumes

```bash
aws ec2 describe-volumes --profile "$PROFILE" --region "$REGION" --query 'Volumes[].{VolumeId:VolumeId,State:State,Size:Size,Type:VolumeType,Attached:Attachments.InstanceId}' --output table
```

Expected: volumes attached to the P1 EC2 instance are `EXPECTED RETAINED`; unattached volumes require investigation.

### 3. Audit Elastic IP addresses

```bash
aws ec2 describe-addresses --profile "$PROFILE" --region "$REGION" --query 'Addresses[].{PublicIp:PublicIp,AllocationId:AllocationId,AssociationId:AssociationId,InstanceId:InstanceId}' --output table
```

Expected: an Elastic IP associated with the P1 EC2 instance is `EXPECTED RETAINED`; an unassociated Elastic IP is `UNEXPECTED` because it can generate cost.

### 4. Audit RDS instances

```bash
aws rds describe-db-instances --profile "$PROFILE" --region "$REGION" --query 'DBInstances[].{DBInstanceIdentifier:DBInstanceIdentifier,Engine:Engine,Status:DBInstanceStatus,Class:DBInstanceClass,MultiAZ:MultiAZ,Storage:AllocatedStorage}' --output table
```

Expected: the P1 private RDS MySQL instance is `available`; no unknown RDS instances appear.

### 5. Audit RDS snapshots

```bash
aws rds describe-db-snapshots --profile "$PROFILE" --region "$REGION" --query 'DBSnapshots[].{SnapshotId:DBSnapshotIdentifier,Status:Status,Created:SnapshotCreateTime,Type:SnapshotType}' --output table
```

Expected: only intentional manual snapshots are `EXPECTED RETAINED`; automatic snapshots follow the configured retention policy.

### 6. Audit NAT gateways

```bash
aws ec2 describe-nat-gateways --profile "$PROFILE" --region "$REGION" --filter "Name=state,Values=available,pending" --query 'NatGateways[].{NatGatewayId:NatGatewayId,State:State,SubnetId:SubnetId}' --output table
```

Expected: no NAT gateway is listed; if one appears, mark it `UNEXPECTED` because NAT gateways generate hourly and data-processing charges.

### 7. Audit S3 buckets and objects

```bash
aws s3api list-buckets --profile "$PROFILE" --query 'Buckets[].Name' --output table
```

```bash
aws s3api list-objects-v2 --profile "$PROFILE" --region "$REGION" --bucket "$BACKUP_BUCKET" --query 'sum(Contents[].Size)' --output text
```

Expected: the P3 backup bucket is `EXPECTED RETAINED`; its object storage size should remain small and justified by the daily log backups.

### 8. Audit CloudWatch alarms

```bash
aws cloudwatch describe-alarms --profile "$PROFILE" --region "$REGION" --query 'MetricAlarms[].{AlarmName:AlarmName,State:StateValue,Actions:AlarmActions}' --output table
```

Expected: the three P3 alarms are `EXPECTED RETAINED`; CloudWatch alarms themselves are low-cost, but their SNS notifications must remain intentional.

### 9. Audit CloudWatch log groups

```bash
aws logs describe-log-groups --profile "$PROFILE" --region "$REGION" --query 'logGroups[].{LogGroupName:logGroupName,StoredBytes:storedBytes}' --output table
```

Expected: log groups used by the running stack are `EXPECTED RETAINED`; unknown or unused log groups with stored data require investigation.

### 10. Audit SNS topics

```bash
aws sns list-topics --profile "$PROFILE" --region "$REGION" --output table
```

Expected: the P3 alarm topic is `EXPECTED RETAINED`; unknown topics require investigation.

## Audit Table

| Resource type | Resource | Audit result | Cost decision |
|---|---|---|---|
| EC2 | P1 application instance | EXPECTED RUNNING | Keep running |
| EBS | P1 EC2 root/data volume | EXPECTED RETAINED | Keep attached |
| Elastic IP | P1 public IP | EXPECTED RETAINED if associated | Keep associated |
| RDS | P1 private MySQL instance | EXPECTED RUNNING | Keep running |
| RDS snapshot | Manual snapshot, if any | EXPECTED RETAINED or UNEXPECTED | Decide after review |
| NAT Gateway | None expected | EXPECTED ABSENT or UNEXPECTED | Remove later only after review |
| S3 | P3 backup bucket | EXPECTED RETAINED | Keep for backups |
| CloudWatch alarm | CPU, memory, disk alarms | EXPECTED RETAINED | Keep |
| CloudWatch log group | Application/container logs | EXPECTED RETAINED or UNEXPECTED | Decide after review |
| SNS topic | P3 alarm topic | EXPECTED RETAINED | Keep |

## Follow-Up Decision Format

For every `UNEXPECTED` resource, record:

```text
Resource type:
Resource ID or name:
Why it exists:
Required by P1/P2/P3:
Cost risk:
Decision:
Safe follow-up command to inspect it further:
```

Do not delete or destroy any resource in this exercise.

## Rules Followed

- No AWS create, modify, delete, terminate, or destroy commands were used.
- P1, P2, and P3 running resources remain untouched.
- Every unexpected resource is documented for a separate decision.
- No secrets, credentials, account IDs, or private values are included in screenshots or public notes.
