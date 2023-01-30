#! /bin/bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get -y update
apt-get -y upgrade
apt-get install -y docker.io
systemctl start docker
systemctl enable docker
groupadd docker
usermod -aG docker ubuntu
curl -L "https://github.com/docker/compose/releases/download/v2.15.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
export DOCKER_BUILDKIT=1
apt-get -y update
apt-get -y upgrade

