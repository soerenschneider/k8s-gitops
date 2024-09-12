#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"

if [[ -f _override.sh ]]; then
  source _override.sh
fi
###########################################################

OUTPUT=$(pass ${K8S_PASS_PATH})
GF_SECURITY_ADMIN_PASSWORD="$(echo "$OUTPUT" | grep -e "^GF_SECURITY_ADMIN_PASSWORD=" | cut -d'=' -f2)"

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--from-literal=GF_SECURITY_ADMIN_PASSWORD="${GF_SECURITY_ADMIN_PASSWORD}" \
	--dry-run=client -o yaml |
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin
