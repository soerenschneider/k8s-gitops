#!/usr/bin/env bash

echo "Enter radarr apikey"
read -s APIKEY

if [[ -z "${APIKEY}" ]]; then
	echo "Empty apikey given"
	exit 1
fi

set -o pipefail
set -eu

K8S_SECRET_NAME="radarr-apikey"
K8S_SECRET_FILE_NAME="radarr-secret-apikey.yaml"

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--from-literal=apikey="${APIKEY}" \
	--dry-run=client -o yaml |
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin
