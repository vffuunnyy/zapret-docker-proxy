#!/bin/bash

if [ ! -f /squid/passwd ]; then
    echo "Error: No /passwd file"
    exit 1
fi

read -e -p "Enter proxy username to delete: " proxy_username

/usr/bin/htpasswd -D /squid/passwd $proxy_username

echo "Done!"
exit 0
