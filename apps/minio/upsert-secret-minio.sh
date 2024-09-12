#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"
###########################################################

OUTPUT=$(pass ${K8S_PASS_PATH})

MINIO_ROOT_USER="$(echo "$OUTPUT" | grep -e "^MINIO_ROOT_USER=" | cut -d'=' -f2)"
MINIO_ROOT_PASSWORD="$(echo "$OUTPUT" | grep -e "^MINIO_ROOT_PASSWORD=" | cut -d'=' -f2)"

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--from-literal=MINIO_ROOT_USER="${MINIO_ROOT_USER}" \
	--from-literal=MINIO_ROOT_PASSWORD="${MINIO_ROOT_PASSWORD}" \
	--dry-run=client -o yaml |
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin