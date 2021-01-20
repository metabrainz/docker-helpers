#!/bin/bash

set -ex

# copy new docker daemon config
CONFFILE=/etc/docker/daemon.json
[ -e "$CONFFILE" ] && cp -fv "$CONFFILE" "$CONFFILE.bak"
cp -fv hetzner_docker_daemon.json "$CONFFILE"

# use live restore feature
# https://docs.docker.com/config/containers/live-restore/

# first, send SIGHUP to docker daemon so it reloads the config
systemctl reload docker.service

# wait 5 seconds
sleep 5

# Ensure live restore is set, and restart docker
if docker info 2>/dev/null|grep -q 'Live Restore Enabled: true'; then
  systemctl restart docker.service
fi

systemctl status docker.service
