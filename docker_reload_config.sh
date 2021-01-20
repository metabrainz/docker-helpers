#!/bin/bash

set -ex

FORCE=0
if [ "$1" = "force" ]; then
  FORCE=1
fi

# copy new docker daemon config
CONFFILE=/etc/docker/daemon.json
SRCFILE=hetzner_docker_daemon.json

if [ -e "$CONFFILE" ]; then
        if [ $FORCE -eq 0 ]; then
		if cmp -s "$SRCFILE" "$CONFFILE"; then
   			echo "$SRCFILE and $CONFFILE are identical, exiting..."
			exit 1
		fi
	fi
 	cp -fv "$CONFFILE" "$CONFFILE.bak"
fi
cp -fv "$SRCFILE" "$CONFFILE"

# use live restore feature
# https://docs.docker.com/config/containers/live-restore/

# first, send SIGHUP to docker daemon so it reloads the config
systemctl reload docker.service

# wait 5 seconds
sleep 5

# Ensure live restore is set, and restart docker
if docker info 2>/dev/null|grep -q 'Live Restore Enabled: true'; then
  systemctl restart docker.service
  sleep 5
fi

systemctl status docker.service
