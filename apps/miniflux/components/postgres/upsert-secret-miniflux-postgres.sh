#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"

echo "Upserting app=${K8S_APP}, cluster=${K8S_CLUSTER_NAME}, pass path=${K8S_PASS_PATH}"

###########################################################

OUTPUT=$(pass ${K8S_PASS_PATH})

POSTGRES_USER="$(echo "$OUTPUT" | grep -e "^POSTGRES_USER=" | cut -d'=' -f2)"
POSTGRES_PASSWORD="$(echo "$OUTPUT" | grep -e "^POSTGRES_PASSWORD=" | cut -d'=' -f2)"

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--from-literal=POSTGRES_USER="${POSTGRES_USER}" \
	--from-literal=POSTGRES_PASSWORD="${POSTGRES_PASSWORD}" \
	--dry-run=client -o yaml |
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin