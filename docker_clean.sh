#!/bin/bash
docker run -ti \
	-v /var/run/docker.sock:/var/run/docker.sock \
	yelp/docker-custodian \
	dcgc --max-image-age 1h --max-container-age 1h
