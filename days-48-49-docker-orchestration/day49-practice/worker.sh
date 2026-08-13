#!/bin/sh
mkdir -p /shared
while true
do
  echo "worker-record: $(date -u)" >> /shared/status.txt
  sleep 5
done
