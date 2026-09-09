# Day 84 — RDS Operations
## What We Are Studying
Manual snapshots (on-demand backups), automated backups (daily + PITR), and parameter groups (tune DB engine settings).
## Commands Used
| Command | Purpose |
|---------|---------|
| `aws rds create-db-snapshot` | Manual backup |
| `aws rds modify-db-instance --backup-retention-period` | Enable automated backups |
| `aws rds create-db-parameter-group` | Custom DB params |
