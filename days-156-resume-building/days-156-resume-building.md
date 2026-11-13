# Day 156/180 — Phase 7, Day 11: Resume Building

## Resume Strategy

Target entry-level Cloud/DevOps Internship or fresher Cloud/DevOps roles in Gujarat, Mumbai, Pune, or remote roles across India. The resume presents personal and learning projects clearly as projects, not employment experience.

## One-Page Resume

```markdown
# DEV SANGHAVI

Pune, Maharashtra, India | Open to Gujarat, Mumbai, Pune, and Remote roles across India  
GitHub: [https://github.com/DevSanghavi](https://github.com/DevSanghavi)  
Email: Add your professional email address manually before applying  
Phone: Add your phone number manually before applying  
LinkedIn: Add your LinkedIn profile URL manually before applying  

## Career Objective

Cloud and DevOps fresher seeking an internship or entry-level role where I can apply hands-on skills in AWS, Linux, Docker, Terraform, GitHub Actions CI/CD, monitoring, and incident troubleshooting. I have completed 155 days of a structured 180-day Cloud/DevOps practice roadmap and built three end-to-end cloud projects using AWS Free Tier.

## Technical Skills

- Cloud: AWS EC2, VPC, IAM, S3, RDS, CloudWatch, SNS, Secrets Manager, Systems Manager, AWS CLI
- Infrastructure as Code: Terraform, remote S3 state, state locking, infrastructure modules
- Containers: Docker, multi-stage builds, Docker Compose, container health checks, image scanning
- CI/CD: GitHub Actions, GitHub Container Registry, automated deployment, staging-to-production promotion, rollback workflows
- Linux and Networking: Ubuntu, Bash, Nginx reverse proxy, CIDR, security groups, SSH, SSM
- Monitoring and Operations: CloudWatch Agent, alarms, systemd timers, logrotate, S3 log backups, incident runbooks
- Developer Tools: Git, GitHub, Git Flow, Node.js, Flask, MySQL

## Projects

### Terraform AWS Infrastructure — Personal Cloud Project  
[https://github.com/DevSanghavi/terraform-aws-infra](https://github.com/DevSanghavi/terraform-aws-infra)

- Provisioned an AWS VPC, public and private subnets, EC2 instance, security groups, S3 remote state backend, and RDS MySQL database using Terraform.
- Deployed a Flask application container on an EC2 t3.micro instance within a custom VPC.
- Configured an S3 remote state backend with locking to support safer Terraform collaboration and automation.
- Resolved real deployment issues involving RDS subnet-group Availability Zone requirements, missing database secrets, local AWS profile configuration, and CI runner dependencies.

### GitOps CI/CD Pipeline — Personal Cloud Project  
[https://github.com/DevSanghavi/gitops-cicd-pipeline](https://github.com/DevSanghavi/gitops-cicd-pipeline)

- Built a GitHub Actions CI/CD pipeline for a Node.js application with Docker image building, GHCR publishing, and automated EC2 deployment.
- Implemented staging-to-production promotion using image digests, deployment workflows, database migrations, rollback support, and failure alerts.
- Configured production Nginx as a reverse proxy on port 80, forwarding traffic to the production API container.
- Deployed a separate staging API on port 8080 to support safer release validation.
- Resolved issues involving missing runner tools, hardcoded Availability Zones, Compose bind-mount errors, Node.js version compatibility, and missing repository secrets.

### DevOps Monitoring Suite — Personal Cloud Project  
[https://github.com/DevSanghavi/devops-monitoring-suite](https://github.com/DevSanghavi/devops-monitoring-suite)

- Implemented CloudWatch Agent-based monitoring for EC2 CPU, memory, and disk usage.
- Created three CloudWatch alarms for CPU above 70 percent, memory above 80 percent, and disk usage above 85 percent, with SNS email notifications.
- Automated daily log backups to S3 using systemd timers and configured logrotate for log retention.
- Built operational runbooks and troubleshooting documentation for real incidents involving SSH access, SSM agent configuration, CloudWatch metric dimensions, and disk monitoring.
- Resolved an `INSUFFICIENT_DATA` disk alarm by identifying and correcting mismatched CloudWatch metric dimensions.

## AWS Training

**AWS Skill Builder — What is AWS?**  
Completed a 12-hour AWS foundational learning course and earned a completion certificate.  
Studied core AWS services, cloud concepts, and AWS service categories.

## Education

**Master of Science in Information Technology (MSc IT), General**  
Pune Institute of Computer Technology, Savitribai Phule Pune University — Currently pursuing  

**Bachelor of Science in Information Technology, Cloud and Application Development**  
Gujarat University, College of Computer and Communication — CGPA: 9.03/10  

**Higher Secondary Certificate (HSC / 12th)** — 65%  

**Secondary School Certificate (SSC / 10th)** — 72%  

## Key Strengths

- Hands-on AWS Free Tier practice across compute, networking, databases, identity, monitoring, and storage services.
- Experience troubleshooting real deployment, Docker, Terraform, networking, monitoring, and database issues.
- Comfortable using AWS Console, AWS CLI, Git, GitHub Actions, Docker, Terraform, and Linux command-line tools.
- Strong interest in Cloud/DevOps, infrastructure automation, observability, and incident response.
```

## LaTeX Resume for Overleaf

### Overleaf Setup

1. Go to https://www.overleaf.com and create a free account.
2. Select **New Project**.
3. Choose **Blank Project**.
4. Name the project `Dev-Sanghavi-DevOps-Resume`.
5. Replace the contents of `main.tex` with the LaTeX code below.
6. Select **Recompile** to generate the PDF.
7. Download the PDF and review it before applying.

```latex
\documentclass[10pt,a4paper]{article}
\usepackage[margin=0.5in]{geometry}
\usepackage[T1]{fontenc}
\usepackage[utf8]{inputenc}
\usepackage{enumitem}
\usepackage{titlesec}
\usepackage{hyperref}
\usepackage{multicol}

\pagestyle{empty}
\setlength{\parindent}{0pt}
\setlength{\parskip}{2pt}
\renewcommand{\labelitemi}{\textbullet}
\titleformat{\section}{\large\bfseries\uppercase}{}{0em}{}[\vspace{-2pt}\rule{\textwidth}{0.4pt}]
\titlespacing{\section}{0pt}{6pt}{4pt}
\hypersetup{colorlinks=true,urlcolor=blue,linkcolor=black}

\begin{document}

\begin{center}
{\LARGE \textbf{DEV SANGHAVI}}\\[2pt]
Pune, Maharashtra, India | Open to Gujarat, Mumbai, Pune, and Remote roles across India\\
\href{[https://github.com/DevSanghavi](https://github.com/DevSanghavi)}{GitHub: DevSanghavi} | Email: Add email manually | Phone: Add phone manually | LinkedIn: Add LinkedIn manually
\end{center}

\section{Career Objective}
Cloud and DevOps fresher seeking an internship or entry-level role where I can apply hands-on skills in AWS, Linux, Docker, Terraform, GitHub Actions CI/CD, monitoring, and incident troubleshooting. Completed 155 days of a structured 180-day Cloud/DevOps practice roadmap and built three end-to-end cloud projects using AWS Free Tier.

\section{Technical Skills}
\begin{itemize}[leftmargin=12pt,itemsep=0pt]
\item \textbf{Cloud:} AWS EC2, VPC, IAM, S3, RDS, CloudWatch, SNS, Secrets Manager, Systems Manager, AWS CLI
\item \textbf{Infrastructure as Code:} Terraform, S3 remote state, state locking, infrastructure modules
\item \textbf{Containers:} Docker, multi-stage builds, Docker Compose, health checks, image scanning
\item \textbf{CI/CD:} GitHub Actions, GitHub Container Registry, automated deployment, staging-to-production promotion, rollback workflows
\item \textbf{Linux and Networking:} Ubuntu, Bash, Nginx reverse proxy, CIDR, security groups, SSH, SSM
\item \textbf{Monitoring and Operations:} CloudWatch Agent, alarms, systemd timers, logrotate, S3 log backups, incident runbooks
\item \textbf{Developer Tools:} Git, GitHub, Git Flow, Node.js, Flask, MySQL
\end{itemize}

\section{Projects}

\textbf{Terraform AWS Infrastructure — Personal Cloud Project} | \href{[https://github.com/DevSanghavi/terraform-aws-infra](https://github.com/DevSanghavi/terraform-aws-infra)}{GitHub}
\begin{itemize}[leftmargin=12pt,itemsep=0pt]
\item Provisioned AWS VPC, public and private subnets, EC2, security groups, S3 remote state backend, and RDS MySQL using Terraform.
\item Deployed a Flask application container on an EC2 t3.micro instance within a custom VPC.
\item Resolved real issues involving RDS subnet-group Availability Zones, missing database secrets, local AWS profile configuration, and CI runner dependencies.
\end{itemize}

\textbf{GitOps CI/CD Pipeline — Personal Cloud Project} | \href{[https://github.com/DevSanghavi/gitops-cicd-pipeline](https://github.com/DevSanghavi/gitops-cicd-pipeline)}{GitHub}
\begin{itemize}[leftmargin=12pt,itemsep=0pt]
\item Built GitHub Actions CI/CD for a Node.js application with Docker image builds, GHCR publishing, and automated EC2 deployment.
\item Implemented staging-to-production promotion using image digests, database migrations, rollback support, and failure alerts.
\item Configured production Nginx on port 80 as a reverse proxy and deployed staging on port 8080.
\item Resolved issues involving missing runner tools, hardcoded Availability Zones, Compose bind mounts, Node.js version compatibility, and missing secrets.
\end{itemize}

\textbf{DevOps Monitoring Suite — Personal Cloud Project} | \href{[https://github.com/DevSanghavi/devops-monitoring-suite](https://github.com/DevSanghavi/devops-monitoring-suite)}{GitHub}
\begin{itemize}[leftmargin=12pt,itemsep=0pt]
\item Implemented CloudWatch Agent monitoring for EC2 CPU, memory, and disk usage.
\item Created CPU, memory, and disk alarms with SNS email notifications.
\item Automated daily S3 log backups using systemd timers and configured logrotate.
\item Built incident runbooks and resolved an `INSUFFICIENT_DATA` disk alarm caused by mismatched CloudWatch metric dimensions.
\end{itemize}

\section{AWS Training}
\textbf{AWS Skill Builder — What is AWS?} | 12-hour foundational course with completion certificate  
Studied core AWS services, cloud concepts, and AWS service categories.

\section{Education}
\textbf{Master of Science in Information Technology (MSc IT), General}  
Pune Institute of Computer Technology, Savitribai Phule Pune University — Currently pursuing

\textbf{Bachelor of Science in Information Technology, Cloud and Application Development}  
Gujarat University, College of Computer and Communication — CGPA: 9.03/10

\textbf{Higher Secondary Certificate (HSC / 12th)} — 65\%  
\textbf{Secondary School Certificate (SSC / 10th)} — 72\%

\section{Key Strengths}
\begin{itemize}[leftmargin=12pt,itemsep=0pt]
\item Hands-on AWS Free Tier practice across compute, networking, databases, identity, monitoring, and storage.
\item Experience troubleshooting real Docker, Terraform, networking, monitoring, and database issues.
\item Comfortable using AWS Console, AWS CLI, Git, GitHub Actions, Docker, Terraform, and Linux.
\item Strong interest in Cloud/DevOps, infrastructure automation, observability, and incident response.
\end{itemize}

\end{document}
```

## Resume Rules

- Add your real email, phone number, and LinkedIn URL before applying; do not include placeholders in the final PDF.
- Keep the resume to one page.
- Label all three repositories as **Personal Cloud Projects**, never as employment.
- Use the exact project links above.
- Do not claim industrial experience, employment, or certifications that you do not have.
- Update the completed-roadmap number only after completing additional days.
