#!/bin/bash

# Original file:
# <https://github.com/serverok/squid-proxy-installer/blob/master/squid-add-user.sh>

read -e -p "Enter Proxy username to add: " proxy_username

if [ -f /passwd ]; then
    /usr/bin/htpasswd /squid_passwd/passwd $proxy_username
else
    /usr/bin/htpasswd -c /squid_passwd/passwd $proxy_username
fi

echo "Restarting squid service... This might take a while"
systemctl restart squid

echo "Done!"
exit 0
