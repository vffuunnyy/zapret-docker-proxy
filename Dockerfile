FROM sameersbn/squid

RUN mkdir -p /var/log/squid3 && \
    chown proxy:proxy /var/log/squid3

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

RUN apt-get install -y curl iptables lsof apache2-utils && \
    apt-get clean

# Setup directories and files

# Copy downloaded programs
COPY zapret /opt/zapret
COPY dnscrypt-proxy /opt/dnscrypt-proxy


# RUN mkdir -p /opt/zapret/configuration

# RUN touch /opt/zapret/configuration/blockcheck_summary.txt && \
#     touch /opt/zapret/configuration/blockcheck.log

# Copy configs
RUN mkdir -p /etc/dnscrypt-proxy
COPY configs/dnscrypt-proxy.toml /etc/dnscrypt-proxy/dnscrypt-proxy.toml
COPY configs/squid.conf /etc/squid/squid.conf

# Copy scripts
COPY scripts/enable_services.sh /opt/zapret/enable_services.sh
COPY scripts/iptables.sh /opt/zapret/iptables.sh
COPY scripts/start_zapret.sh /opt/zapret/start_zapret.sh
COPY scripts/blockcheck_wrapper.sh /opt/zapret/blockcheck_in_container.sh
COPY scripts/add_user.sh /etc/squid/add_user.sh
COPY scripts/delete_user.sh /etc/squid/delete_user.sh

WORKDIR /opt/zapret
COPY /zapret/init.d/custom.d.examples.linux/50-nfqws-ipset /zapret/init.d/sysv/custom.d/50-nfqws-ipset

COPY start.sh /opt/zapret/start.sh

RUN chmod +x ./install_bin.sh ./install_prereq.sh ./install_easy.sh
RUN chmod +x ./enable_services.sh ./iptables.sh ./start_zapret.sh ./start.sh

# Disable default DNS
RUN echo "DNSStubListener=no" >> /etc/systemd/resolved.conf

# Install dnscrypt-proxy service
RUN /opt/dnscrypt-proxy/dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml -service install

# Zapret installation

RUN ./install_bin.sh && \
    echo "1" | ./install_prereq.sh

COPY config /opt/zapret/config

# Add ips to iptables ! Currently unavailable
# RUN ./iptables.sh

CMD [ "/bin/bash" ]
