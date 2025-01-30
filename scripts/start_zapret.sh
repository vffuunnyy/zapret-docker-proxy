#!/bin/bash

# Enable and start services
./enable_services.sh

# Copy existing config to prevent overwriting it
if [ -f "/opt/zapret/config" ]; then
    echo "Renaming config file into /opt/zapret/config_temp to prevent overwriting"
    mv "/opt/zapret/config" "/opt/zapret/config_temp"
fi

# Install zapret
echo "Installing zapret..."
echo -ne "\n" | ./install_easy.sh
echo "zapret installed"

# Restore config
if [ -f "/opt/zapret/config_temp" ]; then
    echo "Restoring config file from /opt/zapret/config_temp"
    mv "/opt/zapret/config_temp" "/opt/zapret/config"
fi

# Restart zapret
echo "Restarting zapret service..."
systemctl restart zapret
echo "Done!"

exit 0
