# Day 159/180 — Phase 7, Day 14: Mock Interview 1

## Interview Instructions

Answer each question aloud in 30–60 seconds. Use your real projects as evidence. Do not memorize answers word for word; explain the concept, give an example from your stack, and mention how you would verify the fix.

## Linux Questions

### 1. What would you check first if a Linux server is slow?

I would check `uptime` for load average, `top` for the highest CPU and memory processes, `free -h` for available memory, and `df -h` for disk capacity. Then I would check container health and resource use with `docker ps` and `docker stats`. I avoid restarting services before identifying what changed.

### 2. What does load average mean?

Load average shows the average number of processes waiting for CPU or disk time. On my one-vCPU EC2 t3.micro, a sustained load average above 1.0 needs investigation, especially if it correlates with slow application responses.

### 3. How do you investigate a full disk?

I first confirm the affected filesystem with `df -h`, then find the largest directories with `du`. I inspect Docker usage with `docker system df` and journal usage with `journalctl --disk-usage`. I rotate or archive logs only after confirming backups and retention requirements. I never delete files first.

### 4. Why can deleting a file fail to free disk space?

If a process still holds an open file descriptor, the operating system may not release the space until that process closes the file or restarts. That is why I investigate the process and rotate logs safely rather than deleting files blindly.

### 5. How do you diagnose a service that will not start?

I check `systemctl status`, `journalctl`, and, for containers, `docker logs`. I look for configuration errors, port conflicts, missing dependencies, or invalid bind mounts. I fix the specific cause, validate the configuration, and only then restart the service.

### 6. What is the difference between a file bind mount and a directory bind mount?

A single-file bind mount is linked to the specific file inode. If an editor replaces the file with a new file, the container may continue seeing the old inode. A directory bind mount follows the directory, so new or replaced files inside it are visible to the container.

### 7. How did you update an Nginx configuration mounted into a container?

I updated the host configuration file using `sudo tee`, then reloaded or restarted Nginx through the approved process. This avoided issues caused by trying to modify a single-file bind mount from inside the container.

### 8. What is systemd?

Systemd is Linux’s service manager. It starts, stops, restarts, and monitors services. I used it for log-backup timers and used `systemctl` and `journalctl` to inspect service failures.

### 9. What is a systemd timer?

A systemd timer schedules a unit to run at a defined time or interval. I used one for daily S3 log backups, with `systemctl list-timers` and logs to verify that the job ran.

### 10. What is logrotate?

Logrotate manages log file rotation, compression, and retention. It prevents logs from growing indefinitely and helps keep disk usage under control.

## Docker Questions

### 11. What is the first thing you check when a container exits immediately?

I check `docker ps -a` for the container status and exit code, then read `docker logs` for the actual startup error. I also use `docker inspect` to check environment variables, command, entrypoint, and image architecture.

### 12. What does exit code 137 usually mean?

Exit code 137 usually means the container process was killed, often due to memory pressure or an external kill signal. I would check `docker inspect` for `OOMKilled`, review memory limits, and identify the process consuming memory.

### 13. How do you diagnose a port-already-in-use error?

I run `docker ps` to see which containers publish which ports, then use `docker port` and `docker inspect` to verify mappings. I determine whether another container or a host process owns the port, then change the mapping or safely stop the conflicting service.

### 14. Why do container IDs and log paths change but container names should not?

Docker assigns a new ID each time a container is recreated, and log paths can change with it. Stable names make automation, monitoring, documentation, and troubleshooting reliable.

### 15. What is the difference between `docker ps` and `docker ps -a`?

`docker ps` shows running containers. `docker ps -a` shows all containers, including stopped and exited containers, which is essential when diagnosing a container that exits immediately.

### 16. What is a Docker image digest?

A digest is an immutable cryptographic identifier for an exact image build. Unlike a mutable tag such as `latest`, a digest guarantees that the same image content is deployed.

### 17. Why did you use image digests in your CI/CD project?

I used image digests for staging-to-production promotion so production could deploy the exact tested image build rather than relying on a tag that could change.

### 18. What causes an image pull denied error?

It can be caused by an incorrect image name or tag, missing or expired registry credentials, insufficient GHCR permissions, a deleted image, or a network restriction. I reproduce the error with `docker pull`, verify the image reference, and check credentials and permissions.

### 19. What is a Docker health check?

A health check is a command Docker runs inside a container to determine whether the application is healthy. It helps distinguish a running container from a container that is running but unable to serve traffic.

### 20. Why did your Node.js container fail with a Node version issue?

The application required Node 22, but the image used Node 18. The failure appeared as an application startup error. I learned to check the application requirements, image version, and container logs together.

## AWS Questions

### 21. What is the difference between a security group and IAM?

A security group controls network access to AWS resources, such as allowing inbound TCP port 80 or 3306. IAM controls what an identity is authorized to do, such as reading an S3 bucket or writing CloudWatch Logs. A security group can block a connection before IAM is involved.

### 22. How do you diagnose an SSH timeout to EC2?

I confirm my current public IP, check the EC2 instance state and public IP, review the security-group inbound rule for TCP port 22, and check the route table. If SSH is not required, I use SSM Session Manager instead.

### 23. How do you diagnose an RDS connection timeout?

I check the RDS endpoint, port, status, and security-group inbound rule for TCP port 3306. Then I test connectivity from the application EC2 instance, because RDS is private and should be reached from within the VPC. If TCP connects but login fails, I investigate credentials and Secrets Manager.

### 24. What is an EC2 instance profile?

An instance profile attaches an IAM role to an EC2 instance, allowing applications on that instance to obtain temporary AWS credentials. I used one to allow the `awslogs` Docker logging driver to write container logs to CloudWatch Logs.

### 25. What happened when your CloudWatch disk alarm showed INSUFFICIENT_DATA?

The alarm’s metric dimensions did not match the actual disk metric dimensions. After correcting them, the alarm evaluated correctly. This taught me to validate monitoring configuration before treating an alert state as proof of an infrastructure problem.

## Weak-Spot Drill

### 26. Explain `awslogs` versus `json-file` Docker log drivers.

`json-file` stores container logs locally on the Docker host in JSON files. `awslogs` sends container logs to Amazon CloudWatch Logs. `json-file` is useful for local debugging, while `awslogs` supports centralized logging, retention, searching, and alarms. My `awslogs` containers initially had empty log paths because the EC2 instance lacked the required IAM role; after attaching the instance profile, CloudWatch Logs could receive the logs.

### 27. What is your disk-full response process?

My process is investigate, preserve evidence, rotate safely, and only then clean up. I use `df -h`, `du`, `docker system df`, and `journalctl --disk-usage` to identify the cause. I verify S3 backups and retention requirements before removing old logs. I never run destructive cleanup as a first response.

### 28. Why are container names more useful than container IDs?

Container IDs and log paths change when containers are recreated. Stable names make commands, monitoring, documentation, and incident response repeatable.

### 29. Explain the single-file bind-mount issue from your project.

A single-file bind mount is tied to the file’s inode. If the host file is replaced by an editor, the container may still see the old inode. I updated the host Nginx configuration using `sudo tee`, then reloaded or restarted Nginx through the approved process.

### 30. How do you separate a network issue from an application issue?

I test the service locally on the EC2 host first. If it works locally but fails externally, I investigate security groups, route tables, public IP configuration, and the client source IP. If it fails locally too, I investigate container status, logs, port mappings, and application configuration.
