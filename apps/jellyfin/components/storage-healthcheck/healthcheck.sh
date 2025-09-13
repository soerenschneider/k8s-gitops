#!/bin/sh

curl -sf http://localhost:8096/health || exit 1

if ! find /media -mindepth 1 -maxdepth 1 -print -quit | grep -q .; then
  echo "Directory is empty. Exiting with failure."
  exit 1
fi