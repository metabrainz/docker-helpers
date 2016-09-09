#!/bin/sh

# This script installs consul-template, runit, and runsvinit (for use as the
# ENTRYPOINT) inside a container.

set -e
cd /root

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    runit \
    unzip

# Install go
GO_RELEASE=go1.7.linux-amd64.tar.gz
curl -O https://storage.googleapis.com/golang/$GO_RELEASE
tar xvf $GO_RELEASE
chown -R root:root go
mv go /usr/local/

# Install runsvinit
export GOPATH=/root/go
mkdir -p $GOPATH
/usr/local/go/bin/go get -u github.com/peterbourgon/runsvinit
cp $GOPATH/bin/runsvinit /usr/local/bin/

## Install consul-template
CT_VERSION=0.15.0
CT_RELEASE="consul-template_${CT_VERSION}_linux_amd64.zip"

curl -O https://releases.hashicorp.com/consul-template/$CT_VERSION/$CT_RELEASE
unzip -d /usr/local/bin $CT_RELEASE
chmod 755 /usr/local/bin/consul-template

mkdir -p /etc/sv/consul-template
cat <<'EOF' > /etc/sv/consul-template/run
#!/bin/sh

exec consul-template \
    -config /etc/consul-template.conf \
    -consul consul:8500
EOF

chmod 755 /etc/sv/consul-template/run
ln -s /etc/sv/consul-template /etc/service/

# These are used inside various .service files
cat <<'EOF' > /etc/consul_template_helpers.sh
function wait_for_file {
    while [ ! -f "$1" ]; do
        sleep 1
    done
}
EOF

# Cleanup
rm -rf \
    $CT_RELEASE \
    $GO_RELEASE \
    $GOPATH \
    /usr/local/go \
    /var/lib/apt/lists/*
