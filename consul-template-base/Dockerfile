FROM metabrainz/runit-base

ARG CT_VERSION="0.16.0"
ARG CT_RELEASE="consul-template_${CT_VERSION}_linux_amd64.zip"

RUN apk add --no-cache --virtual .build-deps curl unzip && \
    curl -O https://releases.hashicorp.com/consul-template/$CT_VERSION/$CT_RELEASE && \
    unzip -d /usr/local/bin $CT_RELEASE && \
    chmod 755 /usr/local/bin/consul-template && \
    rm -rf $CT_RELEASE && \
    apk del .build-deps

COPY consul-template.service /etc/sv/consul-template/run

RUN chmod 755 /etc/sv/consul-template/run && \
    mkdir -p /etc/service/ && \
    ln -s /etc/sv/consul-template /etc/service/

COPY consul_template_helpers.sh /etc/
