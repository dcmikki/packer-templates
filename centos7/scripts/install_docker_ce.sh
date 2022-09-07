#!/usr/bin/env bash
echo "Install Nice packages "
yum install -y vim tree nmap htop net-tools bash-completion htop wget zip unzip jq

echo "Install Docker Compose"
pip install docker-compose


echo "Install Docker CE Latest version"
yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine

yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

yum install -y docker-ce docker-ce-cli containerd.io

echo "Adding user vagrant in docker group"
usermod -aG docker vagrant

systemctl enable docker
systemctl start docker
systemctl status docker
