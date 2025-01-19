#!/bin/bash

echo "Enabling and starting services..."

echo "Reloading systemctl daemon..."
systemctl daemon-reload

echo "Stopping and disabling systemd-resolved service..."
systemctl stop systemd-resolved
systemctl disable systemd-resolved

# Unmount /etc/resolv.conf and install resolvconf if needed
if ! dpkg -s resolvconf &>/dev/null; then
    echo "Installing resolvconf..."
    umount -f /etc/resolv.conf
    apt-get install -y resolvconf
fi

# Set default DNS to dnscrypt-proxy using resolvconf package
echo "Changing default DNS server to dnscrypt-proxy..."
echo "nameserver 127.0.0.1" > /etc/resolvconf/resolv.conf.d/original
echo "options edns0" >> /etc/resolvconf/resolv.conf.d/original
echo "nameserver 127.0.0.1" > /etc/resolvconf/resolv.conf.d/base
echo "options edns0" >> /etc/resolvconf/resolv.conf.d/base
resolvconf -u

echo "Restarting dnscrypt-proxy service..."
/opt/dnscrypt-proxy/dnscrypt-proxy -service restart

# echo "Enabling and restarting systemd-resolved service..."
#systemctl enable systemd-resolved.service
#systemctl restart systemd-resolved.service

echo "Restarting squid service... This might take a while"
systemctl restart squid

echo "Services enabled and started"

exit 0
