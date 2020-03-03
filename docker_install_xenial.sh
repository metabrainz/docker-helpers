#!/bin/bash

# Remove old docker install:
sudo apt-get remove docker docker-engine docker.io containerd runc

# Remove previous old version configs:
sudo mv -f /etc/systemd/system/docker.service.d/systemd_docker.conf /root/etc_systemd_system_docker.service.d_systemd_docker.conf-$(date --iso-8601=seconds)
sudo mv -f /etc/default/docker /root/etc_default_docker-$(date --iso-8601=seconds)

# Install few requirements:

sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common

# Add docker repo:

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# List available docker versions:

sudo apt-get update
sudo apt-cache madison docker-ce docker-ce-cli

# Create json config for docker:

sudo mkdir -p /etc/docker/
cat <<EOF >daemon.json
{
    "dns": ["8.8.8.8", "8.8.4.4"],
    "iptables": false,
    "log-driver": "json-file",
    "log-opts": {
      "max-size": "10m",
      "max-file": "3"
    }
}
EOF
sudo mv -f daemon.json /etc/docker/daemon.json

# Install docker:

sudo apt-mark unhold docker-ce
export DOCKER_VERSION=5:18.09.5~3-0~ubuntu-xenial
sudo apt-get install docker-ce=$DOCKER_VERSION docker-ce-cli=$DOCKER_VERSION containerd.io
sudo apt-mark hold containerd.io docker-ce docker-ce-cli

# Note 1: mark on hold to prevent auto upgrades
# Note 2: docker-ce-cli appeared >= 18.09

systemctl daemon-reload
systemctl status docker

# add current user to docker group
sudo usermod -aG docker $USER



# install docker-compose
# sudo curl -L https://github.com/docker/compose/releases/download/1.8.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose.t && sudo chmod +x /usr/local/bin/docker-compose.t && sudo mv /usr/local/bin/docker-compose.t /usr/local/bin/docker-compose

# install docker completion for bash
# sudo curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose

# http://www.acervera.com/blog/2016/03/05/ufw_plus_docker
if [ -e /etc/default/ufw ]; then
	sudo sed -i 's/^DEFAULT_FORWARD_POLICY=.*$/DEFAULT_FORWARD_POLICY="ACCEPT"/' /etc/default/ufw
	sudo ./docker_ufw_rules.sh
	echo "Please reboot, ufw rules were modified"
else
	echo "Now exit and relog as $USER"
fi
