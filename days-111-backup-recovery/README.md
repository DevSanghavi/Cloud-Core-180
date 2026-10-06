# Day 111 — Backup & Recovery: RPO and RTO
## What We Are Studying
RPO defines maximum acceptable data loss (backup frequency). RTO defines maximum acceptable downtime (recovery speed). AWS snapshots and automated backups help meet both targets.
## Commands Used
| Command | Purpose |
|---------|---------|
| `aws rds create-db-snapshot` | Manual point-in-time backup |
| `aws rds describe-db-snapshots` | List available recovery points |
| `aws rds restore-db-instance-from-db-snapshot` | Recover database from backup |
| `aws rds describe-db-instances` | Check instance status |
