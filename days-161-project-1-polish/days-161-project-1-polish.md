# Day 161 — Project 1 Polish: Final run, screenshot results, write LinkedIn announcement

## Goal

Complete the final read-only validation of `terraform-aws-infra`, collect screenshot evidence, and write a LinkedIn announcement based only on the actual P1 project.

## Project 1

Repository: https://github.com/DevSanghavi/terraform-aws-infra

P1 provisions and runs a Flask application on an EC2 t3.micro Ubuntu 24.04 instance using Terraform, Docker, and Nginx. The Nginx container listens on port 80 and proxies requests to the P2 production API. The EC2 is managed through SSM, and the project uses the AWS resources already running from Days 1-160.

## Final Run Checks

Run from `~/cloud-practice/devops-monitoring-suite` after loading the project environment:

```bash
cd ~/cloud-practice/devops-monitoring-suite
source .env
```

### 1. Verify EC2 instance is running

```bash
aws ec2 describe-instances --profile "$PROFILE" --region "$REGION" --instance-ids "$EC2_INSTANCE_ID" --query 'Reservations[].Instances[].{InstanceId:InstanceId,State:State.Name,PublicIp:PublicIpAddress,Type:InstanceType}' --output table
```

Expected: `State` is `running`; record the instance type and public IP for the screenshot.

### 2. Verify the Flask container is running

```bash
aws ssm send-command --profile "$PROFILE" --region "$REGION" --instance-ids "$EC2_INSTANCE_ID" --document-name "AWS-RunShellScript" --comment "P1 final container check" --parameters '{"commands":["docker ps --format \"table {{.Names}}\\t{{.Status}}\\t{{.Ports}}\""]}' --output json
```

Expected: `terraform-aws-infra-nginx` appears with status `Up` and port `0.0.0.0:80->80/tcp`.

### 3. Verify the public health endpoint

```bash
curl -sS -o /dev/null -w "HTTP %{http_code}\n" "http://$EC2_PUBLIC_IP/"
```

Expected: `HTTP 200`.

### 4. Verify the response body

```bash
curl -sS "http://$EC2_PUBLIC_IP/"
```

Expected: the P1 Flask application response, proxied through Nginx.

### 5. Verify Terraform state resources without changing anything

Run from the P1 repository:

```bash
cd ~/cloud-practice/terraform-aws-infra
terraform state list
```

Expected: Terraform-managed resources used by P1 are listed; no `terraform apply`, `terraform destroy`, or resource deletion is run.

## Screenshot Checklist

Capture and save these screenshots in a local folder outside the project repositories, for example `~/cloud-practice/screenshots/p1-final/`:

1. GitHub repository home page showing `DevSanghavi/terraform-aws-infra`.
2. GitHub Actions run page showing the latest successful workflow.
3. Terminal output showing `HTTP 200` from the public endpoint.
4. Terminal output showing the Flask response from the public endpoint.
5. AWS CLI output showing the EC2 instance is `running`.
6. SSM command output showing `terraform-aws-infra-nginx` is `Up` on port 80.
7. Terraform state list showing the managed resources.
8. README section showing architecture, setup, and deployment instructions.

Do not upload `.env`, private keys, credentials, tokens, account IDs, or any secret values.

## LinkedIn Announcement

Post this text after confirming all checks pass:

```text
Completed Project 1: Terraform AWS Infrastructure.

I built and deployed a Flask application on AWS using Terraform, Docker, and Nginx.

Key work:
- Provisioned AWS infrastructure using Terraform.
- Deployed a Flask application in a Docker container on an EC2 Ubuntu instance.
- Configured Nginx as a reverse proxy on port 80.
- Used AWS SSM for secure instance command execution.
- Added GitHub Actions automation for the project workflow.
- Documented the architecture, setup, and deployment process.

Repository:
[https://github.com/DevSanghavi/terraform-aws-infra](https://github.com/DevSanghavi/terraform-aws-infra)

This project strengthened my practical skills in Terraform, AWS, Docker, Nginx, GitHub Actions, and cloud infrastructure operations.

#AWS #Terraform #DevOps #Docker #Nginx #GitHubActions #CloudComputing
```

## Evidence Log

| Check | Command | Expected result | Screenshot saved |
|---|---|---|---|
| EC2 running | `aws ec2 describe-instances ...` | `running` | Yes |
| Nginx container | SSM `docker ps` | `terraform-aws-infra-nginx` is `Up` | Yes |
| Public endpoint | `curl` | `HTTP 200` | Yes |
| Terraform state | `terraform state list` | Managed resources listed | Yes |
| GitHub Actions | Browser | Latest workflow successful | Yes |
| README | Browser | Setup and architecture documented | Yes |

## Rules Followed

- No AWS create, modify, delete, terminate, or destroy commands were used.
- P1 repository was not edited or pushed from this exercise.
- No secrets, credentials, account IDs, or private values were included in screenshots or the LinkedIn post.
- All claims are based on the actual P1 project and verified outputs.
