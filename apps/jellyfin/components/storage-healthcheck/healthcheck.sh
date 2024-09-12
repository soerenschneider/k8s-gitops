#!/bin/sh

curl -sf http://localhost:8096/health || exit 1

if [ -z "$(ls -A "/media")" ]; then
  echo "Directory is empty. Exiting with failure."
  exit 1
fi
