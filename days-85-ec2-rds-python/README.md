# Day 85 — Connect App to RDS

## What We Are Studying

We will run a Python script on EC2 that connects to an RDS MySQL database.
The script will create a table, insert a record, and read the record.

## Commands Used

| Command | Purpose |
|---------|---------|
| `aws ec2 create-vpc` | Creates the application VPC |
| `aws rds create-db-instance` | Creates the MySQL database |
| `aws ec2 run-instances` | Launches the application server |
| `python3 app.py` | Reads and writes database data |
