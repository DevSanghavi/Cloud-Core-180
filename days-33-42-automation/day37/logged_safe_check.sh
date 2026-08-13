#!/usr/bin/env bash
set -eu

LOG_DIR="$HOME/cloud-practice/day37"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/day37-safe-check.log"

log() {
  local level="$1"
  shift
  local message="$*"
  echo "$(date '+%Y-%m-%d %H:%M:%S') [$level] $message" >> "$LOG_FILE"
}

trap 'log ERROR "script ended"' EXIT

service_name="${1:-}"

if [ -z "$service_name" ]; then
  log WARN "missing service_name argument"
  echo "Usage: $0 <service_name>"
  exit 1
fi

log INFO "checking service $service_name"

if systemctl is-active --quiet "$service_name"; then
  echo "$service_name is running"
  log INFO "$service_name is running"
else
  echo "$service_name is not running"
  log ERROR "$service_name is not running"
  exit 1
fi
