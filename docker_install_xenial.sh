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
sudo systemctl daemon-reload
sudo systemctl restart docker

# install docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose


# install docker completion for bash
sudo curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose

echo "Now exit and relog as $USER"
