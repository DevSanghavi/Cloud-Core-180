# Day 65: Docker Registry and Deployment Versioning

## Why this topic is used

A Docker registry stores images for later deployment.
Version tags identify different application releases.
This supports repeatable deployments and rollbacks.

## What it does

This project builds Docker image versions 1.0 and 1.1.
Both versions are pushed to Docker Hub.
Version 1.1 is deployed to EC2.
Version 1.0 is prepared as a rollback release.

## Where it sits in the cloud stack

Application code is the application layer.
Nginx is the web server layer.
Docker is the packaging layer.
Docker Hub is the image registry layer.
EC2 is the compute layer.
The security group is the network access layer.

## When it is triggered

A new image is built after an application change.
A push happens after a release is tested.
A pull happens during cloud deployment.
A rollback happens when the new release fails.

## Architectural walkthrough

The developer changes application code.
Docker builds a new image.
A unique tag identifies the image version.
Docker pushes the image to Docker Hub.
EC2 pulls the approved version.
The old container is replaced.
The new container serves traffic on port 80.
An older image can restore service during rollback.

## Full practical example commands

mkdir -p ~/cloud-practice/Cloud-Core-180/day-65-docker-registry-versioning
cd ~/cloud-practice/Cloud-Core-180/day-65-docker-registry-versioning
mkdir -p app
cat > app/index.html << 'HTML'
<!DOCTYPE html>
<html>
<head>
  <title>Cloud Mentor OS</title>
</head>
<body>
  <h1>Cloud Mentor OS v6.0</h1>
  <p>Application release: v1.0</p>
  <p>Docker image registry deployment.</p>
</body>
</html>
HTML
cat > Dockerfile << 'DOCKERFILE'
FROM nginx:alpine
COPY app/index.html /usr/share/nginx/html/index.html
EXPOSE 80
DOCKERFILE
docker build -t cloud-mentor-day65:1.0 .
docker run -d --name cloud-mentor-day65-v10 -p 8081:80 cloud-mentor-day65:1.0
curl http://localhost:8081
docker stop cloud-mentor-day65-v10
docker rm cloud-mentor-day65-v10
docker login
read -p "Enter your Docker Hub username: " DOCKER_USER
export DOCKER_USER
docker tag cloud-mentor-day65:1.0 "$DOCKER_USER/cloud-mentor-day65:1.0"
docker push "$DOCKER_USER/cloud-mentor-day65:1.0"
cat > app/index.html << 'HTML'
<!DOCTYPE html>
<html>
<head>
  <title>Cloud Mentor OS</title>
</head>
<body>
  <h1>Cloud Mentor OS v6.0</h1>
  <p>Application release: v1.1</p>
  <p>Docker image registry deployment.</p>
  <p>Feature added: versioned production release.</p>
</body>
</html>
HTML
docker build -t cloud-mentor-day65:1.1 .
docker run -d --name cloud-mentor-day65-v11 -p 8082:80 cloud-mentor-day65:1.1
curl http://localhost:8082
docker stop cloud-mentor-day65-v11
docker rm cloud-mentor-day65-v11
docker tag cloud-mentor-day65:1.1 "$DOCKER_USER/cloud-mentor-day65:1.1"
docker push "$DOCKER_USER/cloud-mentor-day65:1.1"

## Today's practice commands

docker pull YOUR_DOCKER_USERNAME/cloud-mentor-day65:1.1
docker stop cloud-mentor-day65 2>/dev/null || true
docker rm cloud-mentor-day65 2>/dev/null || true
docker run -d --name cloud-mentor-day65 --restart unless-stopped -p 80:80 YOUR_DOCKER_USERNAME/cloud-mentor-day65:1.1
docker ps
curl http://localhost
docker inspect cloud-mentor-day65 --format '{{.Config.Image}}'
curl http://YOUR_EC2_PUBLIC_IP
docker pull YOUR_DOCKER_USERNAME/cloud-mentor-day65:1.0
docker stop cloud-mentor-day65
docker rm cloud-mentor-day65
docker run -d --name cloud-mentor-day65 --restart unless-stopped -p 80:80 YOUR_DOCKER_USERNAME/cloud-mentor-day65:1.0
curl http://localhost
