# Day 96 — GitHub Actions SSH Deploy
## What We Are Studying
Automate deployment to EC2 by having GitHub Actions SSH into the instance using a private key stored as a repository secret. This replaces manual SSH + scp with a repeatable CI/CD step.
## Commands Used
| Command | Purpose |
|---------|---------|
| `ssh -i key.pem ubuntu@HOST` | Manual SSH verification |
| `ssh ubuntu@HOST "command"` | Remote command execution pattern |
| `uses webfactory/ssh-agent@v0.9.0` | Load SSH private key from secrets |
| `uses appleboy/ssh-action@v1.2.0` | Execute commands over SSH in CI |
| `gh secret set EC2_SSH_KEY` | Store private key as repo secret |
