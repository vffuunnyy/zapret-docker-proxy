FROM ubuntu:20.04

# Setup the environment

RUN apt-get update && \ 
    apt-get install -y init && \
    apt-get clean all

ENV container=docker

COPY container.target /etc/systemd/system/container.target

RUN ln -sf /etc/systemd/system/container.target /etc/systemd/system/default.target

ENTRYPOINT ["/sbin/init"]

RUN apt-get update && \
    apt-get install systemd

STOPSIGNAL SIGRTMIN+3

RUN systemctl set-default multi-user.target

# Download essentials

RUN apt-get install -y curl iptables dnsmasq dnscrypt-proxy squid && \
    apt-get clean

# Setup directories and files

COPY zapret /opt/zapret

WORKDIR /opt/zapret

COPY dnscrypt-proxy.toml /etc/dnscrypt-proxy/dnscrypt-proxy.toml
COPY resolv.conf /etc/resolv.conf
COPY enable_services.sh /opt/zapret/enable_services.sh
COPY iptables.sh /opt/zapret/iptables.sh
COPY squid.conf /etc/squid/squid.conf
COPY start_zapret.sh /opt/zapret/start_zapret.sh
COPY start.sh /opt/zapret/start.sh

RUN chmod +x ./install_bin.sh ./install_prereq.sh ./install_easy.sh
RUN chmod +x ./enable_services.sh ./iptables.sh ./start_zapret.sh ./start.sh

# Zapret installation

RUN ./install_bin.sh && \
    echo "1" | ./install_prereq.sh

COPY config /opt/zapret/config

# Add ips to iptables ! Currently unavailable
# RUN ./iptables.sh
    
CMD [ "/bin/bash" ]