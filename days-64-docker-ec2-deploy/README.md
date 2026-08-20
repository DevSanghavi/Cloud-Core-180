# Day 64: Dockerized Application Deployment on EC2

## Why this topic is used

Docker packages an application and its runtime requirements.
This reduces differences between local and cloud environments.

## What it does

This project builds an Nginx Docker image.
The image serves a custom HTML page.
The image runs locally and on AWS EC2.

## Where it sits in the cloud stack

The HTML page is the application layer.
Nginx is the web server layer.
Docker is the packaging and runtime layer.
EC2 is the compute infrastructure layer.
The security group is the network access layer.

## When it is triggered

The image is built after application changes.
The container starts during deployment.
The restart policy starts it after host reboots.

## Architectural walkthrough

The developer creates an HTML page.
The Dockerfile copies it into an Nginx image.
Docker runs the image as a container.
Docker Hub stores the image.
EC2 pulls the image from Docker Hub.
Port 80 receives browser requests.
Docker forwards requests to Nginx.
Nginx returns the HTML page.

## Full practical example commands

mkdir -p ~/cloud-practice/Cloud-Core-180/day-64-docker-ec2-deployment
cd ~/cloud-practice/Cloud-Core-180/day-64-docker-ec2-deployment
mkdir app
cat > app/index.html << 'HTML'
<!DOCTYPE html>
<html>
<head>
  <title>Cloud Mentor OS</title>
</head>
<body>
  <h1>Cloud Mentor OS v6.0</h1>
  <p>Day 64: Dockerized application deployed on AWS EC2.</p>
</body>
</html>
HTML
cat > Dockerfile << 'DOCKERFILE'
FROM nginx:alpine
COPY app/index.html /usr/share/nginx/html/index.html
EXPOSE 80
DOCKERFILE
docker build -t cloud-mentor-day64:1.0 .
docker run -d --name cloud-mentor-day64-local -p 8080:80 cloud-mentor-day64:1.0
curl http://localhost:8080
docker ps
docker stop cloud-mentor-day64-local
docker rm cloud-mentor-day64-local
docker login
read -p "Enter your Docker Hub username: " DOCKER_USER
docker tag cloud-mentor-day64:1.0 "$DOCKER_USER/cloud-mentor-day64:1.0"
docker push "$DOCKER_USER/cloud-mentor-day64:1.0"

## Today's practice commands

docker pull YOUR_DOCKER_USERNAME/cloud-mentor-day64:1.0
docker run -d --name cloud-mentor-day64 --restart unless-stopped -p 80:80 YOUR_DOCKER_USERNAME/cloud-mentor-day64:1.0
docker ps
curl -I http://localhost
curl http://YOUR_EC2_PUBLIC_IP
docker logs cloud-mentor-day64
docker inspect cloud-mentor-day64
