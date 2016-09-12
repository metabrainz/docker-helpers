#!/bin/sh

# This script installs runit and runsvinit (for use as the ENTRYPOINT)
# inside a container.

set -e
cd /root

apk add --no-cache --virtual .build-deps \
    gcc \
    git \
    go \
    musl-dev

apk add \
    --no-cache \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ \
    runit

# Install runsvinit
export GOPATH=/root/go
mkdir -p $GOPATH
go get -u github.com/peterbourgon/runsvinit
cp $GOPATH/bin/runsvinit /usr/local/bin/

# Cleanup
rm -rf $GOPATH

apk del .build-deps
