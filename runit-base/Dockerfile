FROM alpine:3.4

ENV GOPATH /root/go

RUN apk add --no-cache --virtual .build-deps \
        gcc \
        git \
        go \
        musl-dev

RUN apk add \
        --no-cache \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ \
        runit

RUN mkdir -p $GOPATH && \
    go get -u github.com/peterbourgon/runsvinit && \
    cp $GOPATH/bin/runsvinit /usr/local/bin/ && \
    rm -rf $GOPATH && \
    apk del .build-deps
