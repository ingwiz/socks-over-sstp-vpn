FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

#iproute2 \
# Install Dante
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    dante-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 1080/tcp
EXPOSE 1080/udp

ENTRYPOINT ["/usr/sbin/danted", "-f", "/etc/danted.conf"]