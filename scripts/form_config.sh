#!/bin/bash

# blockcheck.sh output
BLOCKCHECK_LOG="./configuration/blockcheck.log"

# Original config file
CONFIG_FILE="./config"

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Error: File $CONFIG_FILE doesn't exist"
  exit 1
fi
# Extract option from first string containing "nfqws" and cut everything before "nfqws"
echo "Extracting FIRST working nfqws option..."
summary_option=$(grep -A 1000 -i "summary" "$BLOCKCHECK_LOG" | grep -B 1000 -i "Please" | grep -v -i "Please" | grep -m1 "nfqws")
summary_option=${summary_option##*"nfqws "}

# Check
if [[ -z "$summary_option" ]]; then
  echo "Error: Unable to extract summary options from $BLOCKCHECK_LOG"
  exit 1
fi

# Form new config params
HTTP_CONF="--filter-tcp=80 $summary_option <HOSTLIST> --new"
HTTPS_CONF="--filter-tcp=443 $summary_option <HOSTLIST> --new"
UDP_CONF="--filter-udp=443 $summary_option <HOSTLIST_NOAUTO>"

# Backup old config
config_old="$CONFIG_FILE.old.$(date +%Y%m%d%H%M%S)"
echo "Existing config file renamed to $config_old"
cp $CONFIG_FILE "$config_old"

# Replace lines in config file
sed -i -E "s|--filter-tcp=80.*<HOSTLIST>.*|$HTTP_CONF|" "$CONFIG_FILE"
sed -i -E "s|--filter-tcp=443.*<HOSTLIST>.*|$HTTPS_CONF|" "$CONFIG_FILE"
sed -i -E "s|--filter-udp=443.*<HOSTLIST_NOAUTO>.*|$UDP_CONF|" "$CONFIG_FILE"

# Log updates
echo "Updated config:"
echo "HTTP: $HTTP_CONF"
echo "HTTPS: $HTTPS_CONF"
echo "UDP: $UDP_CONF"

echo "Done!"
exit 0
