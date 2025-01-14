#!/bin/bash

echo "Enabling and starting services..."

echo "Reloading systemctl daemon..."
systemctl daemon-reload

echo "Stopping systemd-resolved service..."
systemctl stop systemd-resolved

# echo "Restarting dnsmasq.service service..."
# systemctl restart dnsmasq.service

echo "Enabling and restarting dnscrypt-proxy service... This might take a while"
systemctl enable dnscrypt-proxy.service
systemctl restart dnscrypt-proxy.service

# echo "Enabling and restarting systemd-resolved service..."
#systemctl enable systemd-resolved.service
#systemctl restart systemd-resolved.service

echo "Restarting squid service... This might take a while"
systemctl restart squid

echo "Services enabled and started"

exit 0
