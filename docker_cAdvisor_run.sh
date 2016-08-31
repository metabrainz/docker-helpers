#!/bin/bash

INFLUXDB_PORT=8086
INFLUXDB_DB=cadvisor

INFLUXDB_HOST=$1
if [ -z "$INFLUXDB_HOST" ]; then
	echo "Usage: $0 <influxdb_host>"
	exit 1
fi

if ping -q -c 1 -W 10 -q -- "$INFLUXDB_HOST" >/dev/null; then
	docker rm -f cadvisor
	docker run \
		--volume=/:/rootfs:ro \
		--volume=/var/run:/var/run:rw \
		--volume=/sys:/sys:ro \
		--volume=/var/lib/docker/:/var/lib/docker:ro \
		--publish=8080:8080 \
		--detach=true \
		--name=cadvisor google/cadvisor:latest \
			-storage_driver=influxdb \
			-storage_driver_db=$INFLUXDB_DB \
			-storage_driver_host=$INFLUXDB_HOST:$INFLUXDB_PORT \
			-storage_driver_user=cadvisor \
			-storage_driver_secure=False \
			--vmodule=*=4 \
			--housekeeping-interval=1m0s
else
	echo "Cannot ping $INFLUXDB_HOST, cadvisor container is unlikely to work !"
	exit 1
fi
