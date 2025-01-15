#!/bin/bash

# Domain to test on. Pls use only one domain!
TEST_DOMAIN="x.com"

# Output file
LOG_FILE="blockcheck.log"

# Run blockcheck.sh in BATCH mode
DOMAINS="$TEST_DOMAIN" IPVS=4 ENABLE_HTTP=0 ENABLE_HTTPS_TLS12=1 ENABLE_HTTPS_TLS13=1 REPEATS=3 PARALLEL=1 SCANLEVEL=standard BATCH=1 SKIP_IPBLOCK=1 SKIP_TPWS=1 SECURE_DNS=1 ./blockcheck.sh | tee /configuration/"$LOG_FILE"
