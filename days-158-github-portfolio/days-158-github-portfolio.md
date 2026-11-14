# Day 158/180 — Phase 7, Day 13: GitHub Portfolio

## Portfolio Goal

Make your GitHub profile immediately show three practical Cloud/DevOps projects, clear documentation, and visual proof that the systems run.

## Pin All 3 Projects

1. Open your GitHub profile: https://github.com/DevSanghavi
2. Select **Customize your pins**.
3. Select these three repositories:
   - https://github.com/DevSanghavi/terraform-aws-infra
   - https://github.com/DevSanghavi/gitops-cicd-pipeline
   - https://github.com/DevSanghavi/devops-monitoring-suite
4. Select **Save pins**.
5. Confirm that all three repositories appear at the top of your profile.

## README Table of Contents

Add this table of contents block near the top of each project README. Apply the edits by hand in GitHub or your local project repository; do not change project repositories through this chat.

### Terraform AWS Infrastructure

Paste this into `terraform-aws-infra/README.md` after the project title and short description:

```markdown
## Table of Contents

- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [AWS Resources](#aws-resources)
- [Terraform Workflow](#terraform-workflow)
- [Deployment](#deployment)
- [Monitoring](#monitoring)
- [Troubleshooting](#troubleshooting)
- [Project Structure](#project-structure)
- [Lessons Learned](#lessons-learned)
```

### GitOps CI/CD Pipeline

Paste this into `gitops-cicd-pipeline/README.md` after the project title and short description:

```markdown
## Table of Contents

- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [CI/CD Workflow](#cicd-workflow)
- [Docker and GHCR](#docker-and-ghcr)
- [Staging and Production](#staging-and-production)
- [Database Migrations](#database-migrations)
- [Rollback Strategy](#rollback-strategy)
- [Monitoring and Alerts](#monitoring-and-alerts)
- [Troubleshooting](#troubleshooting)
- [Project Structure](#project-structure)
- [Lessons Learned](#lessons-learned)
```

### DevOps Monitoring Suite

Paste this into `devops-monitoring-suite/README.md` after the project title and short description:

```markdown
## Table of Contents

- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [CloudWatch Monitoring](#cloudwatch-monitoring)
- [Alarms and Notifications](#alarms-and-notifications)
- [Log Management](#log-management)
- [S3 Log Backups](#s3-log-backups)
- [Systemd Timers](#systemd-timers)
- [Incident Runbooks](#incident-runbooks)
- [Troubleshooting](#troubleshooting)
- [Project Structure](#project-structure)
- [Lessons Learned](#lessons-learned)
```

## Demo GIF Plan

Use **Kap**, a free and open-source screen recorder for macOS, or **OBS Studio**, which is free and available for Windows, macOS, and Linux. For this WSL2 Ubuntu setup, use OBS Studio.

### OBS Studio Setup

1. Install OBS Studio on the Windows host, since it can record the full desktop and browser.
2. Open OBS Studio and select **Settings**.
3. Go to **Video**.
4. Set base resolution to `1920x1080`.
5. Set output resolution to `1280x720`.
6. Set FPS to `30`.
7. Go to **Output** and choose a recording quality that keeps the file small.
8. Add a **Display Capture** source.
9. Record only the browser window or terminal area; avoid showing personal files, email, credentials, or unrelated tabs.

### GIF Conversion

Use **EZGIF**, a free browser-based tool, to convert a short screen recording into a GIF.

1. Record a 10–20 second demo clip.
2. Open https://ezgif.com/video-to-gif.
3. Upload the recorded video.
4. Set the GIF width to `800` pixels.
5. Select a reasonable frame rate, such as `10` or `12` FPS.
6. Trim the clip to show only the important action.
7. Convert and download the GIF.
8. Add the GIF to the project repository under a folder such as `docs/demo/`.
9. Reference it in the README using a relative path.

## Demo GIF Ideas

### Terraform AWS Infrastructure

Show a terminal running:

```bash
terraform plan
```

Then show the plan output identifying the AWS resources to be created or changed. Do not show secrets, account IDs, or private IP addresses.

### GitOps CI/CD Pipeline

Show the GitHub Actions workflow progressing from build to deployment, then show a successful production deployment. Blur or crop any secrets, tokens, account IDs, or private values.

### DevOps Monitoring Suite

Show a CloudWatch alarm state, CloudWatch metric graph, or S3 log-backup timer status. Do not show private email addresses, account IDs, or sensitive log contents.

## README GIF Example

Add this block to a project README after recording and uploading the GIF:

```markdown
## Demo


```

## Portfolio Quality Checklist

- Pin all three project repositories.
- Add a table of contents to each README.
- Add a short, clear project description at the top of each README.
- Include architecture, workflow, deployment, monitoring, troubleshooting, and lessons-learned sections.
- Add one relevant demo GIF per project.
- Remove secrets, tokens, account IDs, private IPs, and personal information from screenshots and GIFs.
- Ensure every README explains what the project does, how it works, and what was learned.
