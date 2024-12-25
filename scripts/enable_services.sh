#!/bin/bash

### this file runs after the container starts ###

systemctl enable dnscrypt-proxy.service
systemctl start dnscrypt-proxy.service
systemctl enable systemd-resolved.service
systemctl start systemd-resolved.service
systemctl restart squid

echo "services enabled and started"