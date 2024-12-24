#!/bin/bash

./enable_serices.sh

echo "starting zapret"

printf '%s\n' '\n' 'n' '\n' 'n' '\n' 'n' '\n' 'n' | ./install_easy.sh

systemctl tinyproxy restart