FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Dante
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    dante-server \
    iproute2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY . /opt/
WORKDIR /opt/

EXPOSE 1080/tcp
EXPOSE 1080/udp

ENTRYPOINT ["/usr/bin/bash", "/opt/run-danted.sh"]