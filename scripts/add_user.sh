#!/bin/bash

# Original file:
# <https://github.com/serverok/squid-proxy-installer/blob/master/squid-add-user.sh>

read -e -p "Enter proxy username to add: " proxy_username

if [ -f /squid/passwd ]; then
    /usr/bin/htpasswd /squid/passwd $proxy_username
else
    /usr/bin/htpasswd -c /squid/passwd $proxy_username
fi

echo "Reloading squid"
squid -k reconfigure

echo "Done!"
exit 0
