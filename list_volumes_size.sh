#!/bin/bash

docker volume ls -q|while read V; do docker volume inspect $V|grep "Mountpoint"|awk '{print $2}'|tr -d '",'|while read M; do sudo du -h $M; done; done
