FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Dante
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    dante-server \
    iproute2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 1080/tcp
EXPOSE 1080/udp

# Run danted in foreground
ENTRYPOINT ["/usr/sbin/danted", "-f", "/etc/danted.conf"]