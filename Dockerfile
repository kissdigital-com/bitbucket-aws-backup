FROM alpine:3.13

RUN mkdir /opt/bb && apk add --no-cache \
        bash \
        coreutils \
        git \
        curl \
        python3 \
        py3-pip \
    && pip3 install --upgrade pip \
    && pip3 install \
        awscli \
    && rm -rf /var/cache/apk/* && rm -rf /root/.cache

COPY ["docker_bb.sh", "bb.sh", "LICENSE", "README.md", "/opt/bb/"]

WORKDIR /opt/bb/

CMD ["/opt/bb/docker_bb.sh"]

