#!/bin/bash
# ==============================================================================
# AWS EC2 Docker Deployment Script for Spring Boot Application
# Target Host: Ubuntu 24.04 LTS (AWS ap-southeast-2 Sydney)
# ==============================================================================

set -e

echo "[1/6] Elevating to root privileges and navigating to home..."
cd /home/ubuntu

echo "[2/6] Updating APT repositories and installing prerequisites..."
apt-get update -y
apt-get install -y ca-certificates curl

echo "[3/6] Installing Docker..."
apt-get install -y docker.io

echo "[4/6] Verifying Docker installation..."
docker --version
systemctl enable docker
systemctl start docker

echo "[5/6] Pulling Spring Boot Docker image from Docker Hub..."
docker pull sreesanth11/spring-app:v1
docker images

echo "[6/6] Running container on port 8082..."
# Stop and remove existing container if running
docker rm -f spring-container 2>/dev/null || true

# Run spring-container detached, restart policy unless-stopped, exposed on port 8082
docker run -d \
  --name spring-container \
  --restart unless-stopped \
  -p 8082:8082 \
  sreesanth11/spring-app:v1

echo "=============================================================================="
echo "Deployment Successful!"
echo "View container logs with: docker logs -f spring-container"
echo "Access the deployed app at: http://<EC2-PUBLIC-IP>:8082/login"
echo "=============================================================================="
