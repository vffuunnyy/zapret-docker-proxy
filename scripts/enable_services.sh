#!/bin/bash

echo "Enabling and starting services..."

echo "Reloading systemctl daemon..."
systemctl daemon-reload

echo "Stopping and disabling systemd-resolved service..."
systemctl stop systemd-resolved
systemctl disable systemd-resolved

echo "Restarting dnscrypt-proxy service..."
/opt/dnscrypt-proxy/dnscrypt-proxy -service restart

# echo "Enabling and restarting systemd-resolved service..."
#systemctl enable systemd-resolved.service
#systemctl restart systemd-resolved.service

echo "Restarting squid service... This might take a while"
systemctl restart squid

echo "Services enabled and started"

exit 0
