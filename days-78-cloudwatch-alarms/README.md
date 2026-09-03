# Day 78 — CloudWatch Alarms with SNS

## What We Are Studying
CloudWatch Alarms evaluate metrics and change state when thresholds are breached.
SNS topics send email or SMS notifications when alarms enter ALARM state.

## Commands Used
| Command | Purpose |
|---------|---------|
| `aws sns create-topic` | Creates an SNS topic |
| `aws sns subscribe` | Subscribes an email to the topic |
| `aws cloudwatch put-metric-alarm` | Creates a metric alarm |
| `aws cloudwatch describe-alarms` | Verifies alarm configuration |
| `aws cloudwatch set-alarm-state` | Tests alarm notifications |
