#!/bin/bash

# TODO: use latest version
ZAPRET_VERSION_TAG="v69.9"

# Remove old zapret directory if exists
if [ -d "./zapret" ]; then rm -Rf ./zapret; fi

# Download zapret
wget "https://github.com/bol-van/zapret/releases/download/$ZAPRET_VERSION_TAG/zapret-$ZAPRET_VERSION_TAG.tar.gz"
if ! tar -xvzf "zapret-$ZAPRET_VERSION_TAG.tar.gz"; then
    tar xvzf "zapret-$ZAPRET_VERSION_TAG.tar.gz"
fi

# Extract it
rm "zapret-$ZAPRET_VERSION_TAG.tar.gz"
mv "./zapret-$ZAPRET_VERSION_TAG" ./zapret

# Start build script
./start.sh
