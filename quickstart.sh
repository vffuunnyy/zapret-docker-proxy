#!/bin/bash

sudo apt-get update
sudo apt-get install -y wget
sudo wget https://github.com/bol-van/zapret/releases/download/v69.8/zapret-v69.8.tar.gz

if ! sudo tar -xzfv zapret-v69.8.tar.gz; then
    sudo tar xzfv zapret-v69.8.tar.gz
fi

sudo rm zapret-v69.8.tar.gz

sudo mv ./zapret-v69.8 ./zapret

sudo ./start.sh
