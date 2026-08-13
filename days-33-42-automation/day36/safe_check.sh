#!/usr/bin/env bash
set -eu


trap 'echo "cleanup: script ended"' EXIT

service_name="${1:-}"


if [ -z "$service_name" ]; then
  echo "Usage: $0 <service_name>"
  exit 1
fi


if systemctl is-active --quiet "$service_name"; then
  echo "$service_name is running"
else
  echo "$service_name is not running"
  exit 1
fi
