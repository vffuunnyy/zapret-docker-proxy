#!/bin/bash

LOG_FILE="blockcheck.log"
SUMMARY_FILE="blockcheck_summary.txt"

printf '\n' '\n' '\n' '\n' '\n' '\n' '\n' | ./blockcheck.sh | tee /configuration/"$LOG_FILE"

grep -A 1000 -i "summary" /configuration/"$LOG_FILE" | grep -B 1000 -i "Please" | grep -v -i "Please" > /configuration/"$SUMMARY_FILE"