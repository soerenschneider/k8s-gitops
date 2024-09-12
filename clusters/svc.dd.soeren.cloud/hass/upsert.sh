#!/usr/bin/env bash

SECRET_FILE_NAME="sops-ghcr-docker-registry.yaml"

set -eu

read token

if [[ -z "${token}" ]]; then
    echo supply token
    exit 1
fi

kubectl create secret docker-registry ghcr-login-secret \
    --docker-server=https://ghcr.io \
    --docker-username=soerenschneider \
    --docker-password="${token}" \
    -o yaml --dry-run=client | 
	sops -e --input-type=yaml --output-type=yaml -e \
	--output "${SECRET_FILE_NAME}" /dev/stdin
