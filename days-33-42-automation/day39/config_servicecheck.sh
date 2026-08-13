#!/usr/bin/env bash
set -eu

CONFIG_FILE="./day39.conf"

if [ ! -r "$CONFIG_FILE" ]; then
  echo "Missing config file: $CONFIG_FILE"
  exit 1
fi

. "$CONFIG_FILE"

mkdir -p "$LOG_DIR"

STATUS_FILE="$LOG_DIR/day39-status.log"

if systemctl is-active --quiet "$SERVICE_NAME"; then
  echo "$SERVICE_NAME is running"
  echo "$(date '+%Y-%m-%d %H:%M:%S') OK $SERVICE_NAME is running" >> "$STATUS_FILE"
  exit 0
else
  echo "$SERVICE_NAME is not running"
  echo "$(date '+%Y-%m-%d %H:%M:%S') FAIL $SERVICE_NAME is not running" >> "$STATUS_FILE"
  exit 1
fi
