#!/usr/bin/env bash
service_name="nginx"

if systemctl is-active --quiet "$service_name"; then
  echo "service_name is running"
  exit 0
else 
  echo "$service_name is not running"
  exit 1
fi
