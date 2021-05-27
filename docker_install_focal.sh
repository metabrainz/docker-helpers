#!/bin/bash

set -x

# remove old packages
sudo apt-get remove docker docker-engine docker.io containerd runc

# install dependencies
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# add docker repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# install docker packages
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

# default daemon config
sudo cp -f hetzner_docker_daemon_focal.json /etc/docker/daemon.json

UFW_DOCKER=no
if [ "$UFW_DOCKER" = "yes" ]; then
	sudo cp -f hetzner_docker_daemon_focal_ufw_docker.json /etc/docker/daemon.json
	# install ufw-docker
	sudo wget -O /usr/local/bin/ufw-docker \
	  https://github.com/chaifeng/ufw-docker/raw/master/ufw-docker
	sudo chmod +x /usr/local/bin/ufw-docker

	sudo ufw-docker install
	sudo systemctl restart ufw.service
else
	sudo ./docker_ufw_rules.sh
	sudo systemctl restart ufw.service
fi

# prevent automatic upgrades of docker packages
sudo apt-mark hold docker-ce docker-ce-cli containerd.io

sudo systemctl restart docker.service
