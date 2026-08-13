#!/usr/bin/env bash

check_service() {
  local service_name="$1"

  if systemctl is-active --quiet "$service_name"; then
    echo "$service_name is running"
    return 0
  else
    echo "$service_name is not running"
    return 1
  fi
}

main() {
  if [ -z "$1" ]; then
    echo "Usage: $0 <service_name>"
    exit 1
  fi

  check_service "$1"
  exit $?
}

main "$@"
