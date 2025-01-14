#!/bin/bash

# Enable and start services
./enable_services.sh

# Install zapret
echo "Installing zapret..."
printf '%s\n' '\n' 'n' '\n' 'n' '\n' 'n' '\n' 'n' | ./install_easy.sh
echo "zapret installed"

echo "Done!"
exit 0
