FROM metabrainz/base-image

ARG CT_VERSION="0.16.0"
ARG CT_RELEASE="consul-template_${CT_VERSION}_linux_amd64.zip"

RUN curl -O https://releases.hashicorp.com/consul-template/$CT_VERSION/$CT_RELEASE && \
    unzip -d /usr/local/bin $CT_RELEASE && \
    chmod 755 /usr/local/bin/consul-template && \
    rm -rf $CT_RELEASE /var/lib/apt/lists/*

COPY consul-template.service /etc/service/consul-template/run
COPY consul_template_helpers.sh /etc/

RUN chmod 755 /etc/service/consul-template/run
