#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"
###########################################################

OUTPUT=$(pass ${K8S_PASS_PATH})

MICROBIN_ADMIN="$(echo "$OUTPUT" | grep -e "^MICROBIN_ADMIN=" | cut -d'=' -f2)"
MICROBIN_ADMIN_PASS="$(echo "$OUTPUT" | grep -e "^MICROBIN_ADMIN_PASS=" | cut -d'=' -f2)"

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--from-literal=MICROBIN_ADMIN_USERNAME="${MICROBIN_ADMIN}" \
	--from-literal=MICROBIN_ADMIN_PASSWORD="${MICROBIN_ADMIN_PASS}" \
	--dry-run=client -o yaml |
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin
