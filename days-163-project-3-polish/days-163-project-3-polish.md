# Day 163 — Project 3 Polish: Final run, screenshot results, write LinkedIn announcement

## Goal

Complete the final read-only validation of `devops-monitoring-suite`, collect screenshot evidence, and write a LinkedIn announcement based only on the actual P3 project.

## Project 3

Repository: https://github.com/DevSanghavi/devops-monitoring-suite

P3 provides operational monitoring and backup automation for the running project stack. It includes three CloudWatch alarms for CPU, memory, and disk usage, SNS email notifications, a daily systemd-timer log backup to S3, logrotate configuration, and a CloudWatch dashboard.

## Final Run Checks

Run from `~/cloud-practice/devops-monitoring-suite` after loading the project environment:

```bash
cd ~/cloud-practice/devops-monitoring-suite
source .env
```

### 1. Verify the three CloudWatch alarms

```bash
aws cloudwatch describe-alarms --profile "$PROFILE" --region "$REGION" --alarm-names "HighCPUUtilization" "HighMemoryUtilization" "HighDiskUtilization" --query 'MetricAlarms[].{AlarmName:AlarmName,State:StateValue,Threshold:Threshold,Actions:AlarmActions}' --output table
```

Type the three exact alarm names used in the P3 project if they differ from the names above; alarm names are fixed identifiers and must match the resources created earlier.

Expected: all three alarms are listed with state `OK` or `INSUFFICIENT_DATA`, and each has an SNS action configured.

### 2. Verify the SNS subscription

```bash
aws sns list-subscriptions-by-topic --profile "$PROFILE" --region "$REGION" --topic-arn "PASTE_THE_SNS_TOPIC_ARN_HERE" --output table
```

Type the actual SNS topic ARN from the P3 `.env` or Terraform output; do not display or screenshot the full email address if it is private.

Expected: the subscription status is `Confirmed`.

### 3. Verify the systemd timer is enabled and active

```bash
aws ssm send-command --profile "$PROFILE" --region "$REGION" --instance-ids "$EC2_INSTANCE_ID" --document-name "AWS-RunShellScript" --comment "P3 final timer check" --parameters '{"commands":["systemctl is-enabled backup-logs.timer; systemctl is-active backup-logs.timer; systemctl list-timers backup-logs.timer --no-pager"]}' --output json
```

Type the exact timer unit name configured in P3 if it differs from `backup-logs.timer`; the timer name is fixed by the P3 systemd unit file.

Expected: the command is submitted successfully and returns `enabled`, `active`, and the next scheduled run time.

### 4. Retrieve the SSM command result

Copy the `CommandId` returned by the previous command, then run:

```bash
aws ssm get-command-invocation --profile "$PROFILE" --region "$REGION" --command-id "PASTE_THE_COMMAND_ID_HERE" --instance-id "$EC2_INSTANCE_ID" --query '{Status:Status,Output:StandardOutputContent}' --output json
```

Type the actual `CommandId` between the quotation marks; it is a temporary SSM command identifier returned by AWS.

Expected: `Status` is `Success`; output shows the timer is enabled, active, and has a next run time.

### 5. Verify the S3 backup bucket and recent objects

```bash
aws s3api list-objects-v2 --profile "$PROFILE" --region "$REGION" --bucket "PASTE_THE_BACKUP_BUCKET_NAME_HERE" --query 'sort_by(Contents,&LastModified)[-5:].{Key:Key,Size:Size,LastModified:LastModified}' --output table
```

Type the exact backup bucket name from the P3 `.env` or Terraform output; bucket names are fixed resource identifiers.

Expected: recent backup objects are listed with non-zero sizes and recent `LastModified` timestamps.

### 6. Verify the CloudWatch dashboard exists

```bash
aws cloudwatch list-dashboards --profile "$PROFILE" --region "$REGION" --query 'DashboardEntries[].DashboardName' --output table
```

Expected: the P3 dashboard name appears in the output.

## Screenshot Checklist

Capture and save these screenshots in a local folder outside the project repositories, for example `~/cloud-practice/screenshots/p3-final/`:

1. GitHub repository home page showing `DevSanghavi/devops-monitoring-suite`.
2. GitHub Actions page showing the latest successful workflow.
3. AWS CLI output showing all three CloudWatch alarms and their states.
4. AWS CLI output showing the SNS subscription is `Confirmed`.
5. SSM result showing the backup timer is enabled and active.
6. AWS CLI output showing recent S3 backup objects.
7. AWS CLI output showing the CloudWatch dashboard name.
8. CloudWatch dashboard page showing the configured monitoring widgets.
9. README section showing monitoring, alarms, backup schedule, restore guidance, and dashboard setup.

Do not upload `.env`, private keys, credentials, tokens, account IDs, or any secret values.

## LinkedIn Announcement

Post this text after confirming all checks pass:

```text
Completed Project 3: DevOps Monitoring Suite.

I built monitoring and backup automation for a cloud-hosted application environment.

Key work:
- Created CloudWatch alarms for CPU, memory, and disk utilization.
- Configured SNS email notifications for alarm alerts.
- Automated daily log backups from an EC2 instance to Amazon S3 using a systemd timer.
- Added logrotate configuration to manage log growth safely.
- Created a CloudWatch dashboard for operational visibility.
- Documented the monitoring, backup, and recovery workflow.

Repository:
[https://github.com/DevSanghavi/devops-monitoring-suite](https://github.com/DevSanghavi/devops-monitoring-suite)

This project strengthened my practical skills in AWS CloudWatch, SNS, S3, EC2, systemd, logrotate, and operational monitoring.

#AWS #CloudWatch #SNS #AmazonS3 #DevOps #Monitoring #Systemd #CloudComputing
```

## Evidence Log

| Check | Command or location | Expected result | Screenshot saved |
|---|---|---|---|
| CloudWatch alarms | `aws cloudwatch describe-alarms ...` | Three alarms listed with actions | Yes |
| SNS subscription | `aws sns list-subscriptions-by-topic ...` | `Confirmed` | Yes |
| Backup timer | SSM `systemctl` result | Enabled and active | Yes |
| S3 backups | `aws s3api list-objects-v2 ...` | Recent non-empty backup objects | Yes |
| Dashboard | `aws cloudwatch list-dashboards ...` | P3 dashboard listed | Yes |
| GitHub Actions | Browser | Latest workflow successful | Yes |
| README | Repository | Monitoring and recovery documented | Yes |

## Rules Followed

- No AWS create, modify, delete, terminate, or destroy commands were used.
- P3 repository was not edited or pushed from this exercise.
- No alarms, subscriptions, timers, S3 objects, or dashboard resources were changed.
- No secrets, credentials, account IDs, or private values were included in screenshots or the LinkedIn post.
- All claims are based on the actual P3 project and verified outputs.
