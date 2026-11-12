# Day 151/180 — Phase 7, Day 6: Terraform Scenarios

## Scenario 1 — State drift

### Symptom
`terraform plan` shows unexpected create, update, or destroy changes even though the Terraform configuration has not changed. The real infrastructure and Terraform state no longer match.

### Likely causes
1. Someone changed an AWS resource directly in the console.
2. A resource was modified by another automation tool, script, or team member.
3. The Terraform state file is outdated, missing, or was restored incorrectly.
4. A resource was recreated outside Terraform, such as manually replacing an EC2 instance.
5. Terraform configuration uses an attribute that AWS changes automatically.

### Triage
Run from `~/cloud-practice/terraform-aws-infra` after configuring the approved AWS profile and backend.

```bash
terraform version
```

Meaning: confirms the Terraform version and helps identify version-specific behavior.

```bash
terraform init -input=false
```

Meaning: initializes the backend and providers without making an interactive prompt.

```bash
terraform validate
```

Meaning: checks Terraform configuration syntax and internal consistency.

```bash
terraform plan -input=false -out=drift-plan.tfplan
```

Meaning: compares the desired configuration with the current state and shows proposed changes. Review the plan carefully before applying anything.

```bash
terraform show -no-color drift-plan.tfplan
```

Meaning: displays the saved plan in a readable format for review.

```bash
terraform state list
```

Meaning: lists resources tracked in the Terraform state.

```bash
terraform state show RESOURCE_ADDRESS
```

Meaning: shows the attributes Terraform has recorded for one resource.

### Fix
1. Identify which resource drifted and compare its Terraform configuration, state attributes, and live AWS resource.
2. Determine who or what made the change before modifying Terraform.
3. If the console change is correct and should remain, update the Terraform configuration to match the approved change, then run `terraform plan` again.
4. If the console change is incorrect, use the approved Terraform workflow to restore the intended configuration.
5. Never run `terraform destroy` as a response to drift.
6. Apply changes only after a reviewed plan confirms the expected create, update, or destroy actions.
7. Record the incident, cause, resolution, and prevention step.

### Prevention
- Treat the console as read-only for Terraform-managed resources.
- Require pull-request review and CI plan checks for infrastructure changes.
- Use remote state with locking.
- Limit direct production access through IAM permissions.
- Run `terraform plan` before every apply.

### Real incident
My Terraform CD pipeline once failed because the backend referenced a local AWS profile and a required database password secret was missing. This taught me that a Terraform failure can come from backend, credentials, or missing secrets rather than a resource-drift problem.

### 30-second interview answer
“State drift means the real infrastructure no longer matches Terraform state. I first run `terraform plan` to see exactly what Terraform wants to change, then investigate whether someone modified the resource in the console or through another tool. If the change is approved, I update the Terraform configuration; if it is not, I restore the intended configuration through a reviewed Terraform change. I never run destroy as a first response.”

## Scenario 2 — Manual console changes

### Symptom
A resource was changed directly in the AWS Console, and Terraform now reports a difference between the configuration, state, and live resource.

### Likely causes
1. An engineer changed a security-group rule, tag, instance type, or database setting directly.
2. An automated AWS service modified a resource.
3. A resource was created manually and is not managed by Terraform.
4. A Terraform apply was interrupted or failed partway through.
5. The resource was imported incorrectly or is missing from state.

### Triage
Run from `~/cloud-practice/terraform-aws-infra` after configuring the approved AWS profile and backend.

```bash
terraform state list
```

Meaning: confirms which resources Terraform currently tracks.

```bash
terraform plan -input=false -out=console-drift-plan.tfplan
```

Meaning: identifies the difference between desired configuration and current infrastructure.

```bash
terraform show -no-color console-drift-plan.tfplan
```

Meaning: shows the proposed changes before any apply.

```bash
terraform state show RESOURCE_ADDRESS
```

Meaning: compares Terraform’s recorded values with the expected configuration.

```bash
aws ec2 describe-instances \
  --instance-ids "$EC2_INSTANCE_ID" \
  --query 'Reservations[].Instances[].{InstanceId:InstanceId,State:State.Name,Type:InstanceType,Tags:Tags}' \
  --output table
```

Meaning: confirms the live EC2 attributes without changing anything.

```bash
aws ec2 describe-security-groups \
  --group-ids "$SG_ID" \
  --query 'SecurityGroups[].{GroupId:GroupId,GroupName:GroupName,IpPermissions:IpPermissions}' \
  --output json
```

Meaning: confirms the live security-group rules without changing anything.

### Fix
1. Confirm whether the console change was intentional, approved, and documented.
2. If it should remain, update the Terraform configuration through a reviewed pull request.
3. Run `terraform plan` and verify that the plan matches the approved outcome.
4. If the change must be removed, restore the original configuration and apply only after review.
5. If a resource is unmanaged, decide whether to import it into Terraform or document it as manually managed.
6. Never manually edit the remote state file to make a plan look clean.

### Prevention
- Restrict console write access for Terraform-managed resources.
- Use Terraform for all approved infrastructure changes.
- Require plan review and approval before apply.
- Maintain a change log for any emergency console change.
- Import exceptional resources deliberately and document their ownership.

### Real incident
My Terraform CD pipeline failed because the backend configuration relied on a local AWS profile, which is unsuitable for an automated runner. The correct approach was to make the backend and credentials work through the approved CI/CD configuration rather than changing resources manually in the console.

### 30-second interview answer
“When someone changes a resource in the console, I first determine whether the change was intentional and approved. I run `terraform plan` to see the drift, then either update Terraform to adopt the approved change or restore the intended configuration through a reviewed change. I never edit state manually or run destroy to force alignment.”

## Scenario 3 — Lock file errors

### Symptom
Terraform reports an error such as `Error acquiring the state lock`, `lock timeout`, or a lock file already exists. Another Terraform process may be running, or a previous run may have left a lock behind.

### Likely causes
1. Another `terraform apply` or `terraform plan` is currently running.
2. A previous Terraform run crashed and left a stale lock.
3. Two engineers or CI jobs ran Terraform at the same time.
4. The backend lock timeout is too short for a long-running operation.
5. The IAM identity lacks permission to acquire or release the backend lock.

### Triage
Run from `~/cloud-practice/terraform-aws-infra` after configuring the approved AWS profile and backend.

```bash
terraform version
```

Meaning: confirms the Terraform version.

```bash
terraform init -input=false
```

Meaning: verifies backend initialization and may reveal a lock-related error.

```bash
terraform plan -input=false -lock-timeout=5m -out=lock-check-plan.tfplan
```

Meaning: attempts to obtain the state lock with a longer timeout and shows whether the lock is temporary or stale.

```bash
terraform force-unlock LOCK_ID
```

Meaning: releases a known stale lock. Run this only after confirming that no Terraform process is actively using the lock.

```bash
aws dynamodb describe-table \
  --table-name "$LOCK_TABLE_NAME" \
  --query 'Table.{TableName:TableName,TableStatus:TableStatus,ItemCount:ItemCount}' \
  --output table
```

Meaning: checks the DynamoDB lock table used by the S3 backend, if applicable.

```bash
aws dynamodb scan \
  --table-name "$LOCK_TABLE_NAME" \
  --output json
```

Meaning: inspects lock records. This is read-only and should be used only to identify the lock holder and metadata.

### Fix
1. Confirm that no other engineer, terminal, or CI job is currently running Terraform.
2. Wait for the active operation to finish if the lock is legitimate.
3. If the lock is stale, identify the lock ID and confirm that the original process is no longer running.
4. Use `terraform force-unlock LOCK_ID` only after that confirmation.
5. Re-run `terraform init` and `terraform plan` after the lock is released.
6. If lock permission is the issue, correct the IAM policy through the approved access-change process.

### Prevention
- Run one Terraform operation at a time per backend.
- Use remote state with DynamoDB locking.
- Set a reasonable lock timeout.
- Ensure CI jobs do not run concurrent Terraform applies.
- Document the lock-release procedure for emergencies.

### Real incident
My Terraform CD workflow failed because the backend used a local AWS profile, preventing the automated runner from accessing the remote backend correctly. This showed me that backend configuration, credentials, and locking must all work together before Terraform can safely plan or apply changes.

### 30-second interview answer
“When Terraform cannot acquire a state lock, I first confirm whether another plan or apply is actively running. If the lock is legitimate, I wait. If it is stale, I identify the lock ID, confirm the original process has ended, and use `terraform force-unlock` only then. I never blindly force-unlock because it could allow two Terraform processes to modify the same infrastructure.”
