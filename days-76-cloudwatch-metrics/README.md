# Day 76 — CloudWatch Metrics: CPU, Disk (EBS), and Network for EC2

## What We Are Studying
We are learning the core CloudWatch metrics for EC2: CPU utilization, network in/out, and disk I/O via EBS metrics. These are essential for monitoring, troubleshooting, and entry-level cloud interviews.

## Commands Used
| Command | Purpose |
|---------|---------|
| `aws cloudwatch list-metrics --namespace AWS/EC2` | List all EC2 metrics. |
| `aws cloudwatch get-metric-statistics ... CPUUtilization ...` | Fetch CPU utilization for an instance. |
| `aws cloudwatch get-metric-statistics ... NetworkIn/Out ...` | Fetch network traffic metrics. |
| `aws cloudwatch list-metrics --namespace AWS/EBS` | List EBS volume metrics. |
| `aws cloudwatch get-metric-statistics ... VolumeRead/WriteBytes ...` | Fetch disk I/O metrics for an EBS volume. |

## Architecture
- Existing EC2 instance from Day 75 (or any t2/t3 micro).
- CloudWatch collecting default metrics: CPU, network, status checks.
- EBS volumes exposing disk I/O metrics under `AWS/EBS` namespace.

## Steps Performed
1. Listed EC2 metrics in CloudWatch.
2. Fetched CPU utilization for a specific instance over the last hour.
3. Fetched NetworkIn and NetworkOut for the same instance.
4. Identified the root EBS volume ID for the instance.
5. Fetched VolumeReadBytes and VolumeWriteBytes for that volume.
6. Reviewed the same metrics in the AWS Console.

## Troubleshooting Notes
- If no data appears, ensure the instance was running during the time window.
- Disk usage inside the OS (e.g., `df -h`) is not a CloudWatch metric by default; only EBS I/O is.
- Custom metrics (e.g., memory usage) require the CloudWatch agent.

## Lessons Learned
- EC2 default metrics: CPU, network, status checks.
- Disk I/O is monitored at the EBS volume level, not as “disk % used”.
- CLI `get-metric-statistics` is powerful for scripting and automation.
