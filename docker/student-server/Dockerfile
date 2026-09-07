FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    sudo \
    iproute2 \
    iputils-ping \
    curl \
    net-tools \
    nano \
    vim \
    dnsutils \
    traceroute \
    procps \
    rsync \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash student \
    && usermod -aG sudo student \
    && echo 'student ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/student

RUN mkdir -p /backups && chown student:student /backups

CMD ["sleep", "infinity"]
