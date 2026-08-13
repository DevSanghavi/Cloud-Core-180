#!/usr/bin/env bash
set -eu

verbose=false
quiet=false

while getopts "vq" opt; do
  case "$opt" in
    v) verbose=true ;;
    q) quiet=true ;;
    \?) echo "Usage: $0 [-v|-q] <service_name>"; exit1 ;;
  esac
done

shift $((OPTIND - 1))

service_name="${1:-}"

if [ -z "$service_name" ]; then
  echo "Usage: $0 [-v|-q] <service_name>"

  exit 1
fi

if systemctl is-active --quiet "$service_name"; then
  if [ "$quiet" = false ]; then
    echo "$service_name is running"
  fi

  if [ "$verbose" = true ]; then
    systemctl status "$service_name"
  fi

  exit 0
else
  echo "$service_name is not running"
  exit 1
fi
