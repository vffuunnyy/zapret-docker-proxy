#!/bin/bash

# TODO: use latest versions
ZAPRET_TAG="v69.9"
DNSCRYPT_PROXY_TAG="2.1.7"

# Remove old zapret directory if exists
if [ -d "./zapret" ]; then rm -Rf ./zapret; fi

# Download zapret
wget "https://github.com/bol-van/zapret/releases/download/$ZAPRET_TAG/zapret-$ZAPRET_TAG.tar.gz"
if ! tar -xvzf "zapret-$ZAPRET_TAG.tar.gz"; then
    tar xvzf "zapret-$ZAPRET_TAG.tar.gz"
fi

# Extract it
rm "zapret-$ZAPRET_TAG.tar.gz"
mv "./zapret-$ZAPRET_TAG" ./zapret

# Remove old dnscrypt-proxy directory if exists
if [ -d "./dnscrypt-proxy" ]; then rm -Rf ./dnscrypt-proxy; fi

# Download dnscrypt-proxy
wget "https://github.com/DNSCrypt/dnscrypt-proxy/releases/download/$DNSCRYPT_PROXY_TAG/dnscrypt-proxy-linux_x86_64-$DNSCRYPT_PROXY_TAG.tar.gz"
if ! tar -xvzf "dnscrypt-proxy-linux_x86_64-$DNSCRYPT_PROXY_TAG.tar.gz"; then
    tar xvzf "dnscrypt-proxy-linux_x86_64-$DNSCRYPT_PROXY_TAG.tar.gz"
fi

# Extract it
rm "dnscrypt-proxy-linux_x86_64-$DNSCRYPT_PROXY_TAG.tar.gz"
mv "./linux-x86_64" ./dnscrypt-proxy

# Start build script
./start.sh
