#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"
###########################################################

OUTPUT=$(pass ${K8S_PASS_PATH})

ADMIN_USERNAME="$(echo "$OUTPUT" | grep -e "^ADMIN_USERNAME=" | cut -d'=' -f2)"
ADMIN_PASSWORD="$(echo "$OUTPUT" | grep -e "^ADMIN_PASSWORD=" | cut -d'=' -f2)"

DATABASE_URL=

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--namespace="${K8S_NAMESPACE}" \
	--from-literal=ADMIN_USERNAME="${ADMIN_USERNAME}" \
	--from-literal=ADMIN_PASSWORD="${ADMIN_PASSWORD}" \
	--from-literal=DATABASE_URL="${DATABASE_URL}" \
	--dry-run=client -o yaml |
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin
