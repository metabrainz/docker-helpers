#!/bin/bash

# install docker
wget -qO- https://get.docker.io/ | sh

# add current user to docker group
sudo usermod -aG docker $USER

# allow env vars to be passed to docker, fix for systemd
sudo mkdir -p /etc/systemd/system/docker.service.d

cat <<\EOF > systemd_docker.conf
[Service]
EnvironmentFile=-/etc/default/docker
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// $DOCKER_OPTS
EOF
sudo cp systemd_docker.conf /etc/systemd/system/docker.service.d/

sudo sed -i 's/^#DOCKER_OPTS=/DOCKER_OPTS=/' /etc/default/docker
sudo sed -i 's/^DOCKER_OPTS=.*$/DOCKER_OPTS="--dns 8.8.8.8 --dns 8.8.4.4 --iptables=false"/' /etc/default/docker
sudo systemctl daemon-reload
sudo systemctl restart docker

# install docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.8.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose.t && sudo chmod +x /usr/local/bin/docker-compose.t && sudo mv /usr/local/bin/docker-compose.t /usr/local/bin/docker-compose

# install docker completion for bash
sudo curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose

# http://www.acervera.com/blog/2016/03/05/ufw_plus_docker
if [ -e /etc/default/ufw ]; then
	sudo sed -i 's/^DEFAULT_FORWARD_POLICY=.*$/DEFAULT_FORWARD_POLICY="ACCEPT"/' /etc/default/ufw
	sudo ./docker_ufw_rules.sh
	echo "Please reboot, ufw rules were modified"
else
	echo "Now exit and relog as $USER"
fi
