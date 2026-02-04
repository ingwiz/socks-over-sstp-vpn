FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y --no-install-recommends \
    sstp-client gettext iproute2 openssl iputils-ping \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY . /opt/sstp
WORKDIR /opt/sstp/

CMD [ "/bin/bash", "/opt/sstp/run-sstp-client.sh" ]
