#!/bin/bash
set -e

# == Docker ====================================================================
apt-get update -y
apt-get install -y ca-certificates curl lsb-release

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

usermod -aG docker azureuser
systemctl enable docker
systemctl start docker

# == Jenkins custom image (inclui Docker CLI) ==================================
# A imagem oficial jenkins/jenkins:lts não inclui Docker CLI.
# Criamos uma imagem customizada seguindo a documentação oficial do Jenkins.
mkdir -p /opt/jenkins

cat > /opt/jenkins/Dockerfile <<'EOF'
FROM jenkins/jenkins:lts-jdk21
USER root
RUN apt-get update && apt-get install -y lsb-release ca-certificates curl && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
    https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
    | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && apt-get install -y docker-ce-cli && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow json-path-api"
EOF

docker build -t jenkins-lab:latest /opt/jenkins/

# == Rede Docker para Jenkins + DinD ==========================================
docker network create jenkins || true

# Docker-in-Docker (DinD): permite que o Jenkins execute comandos Docker
docker run \
  --name jenkins-docker \
  --detach \
  --privileged \
  --restart unless-stopped \
  --network jenkins \
  --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-data:/var/jenkins_home \
  docker:dind \
  --storage-driver overlay2

# Jenkins conectado ao DinD
docker run \
  --name jenkins \
  --detach \
  --restart unless-stopped \
  --network jenkins \
  --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client \
  --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 \
  --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  jenkins-lab:latest
