#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"
###########################################################

OUTPUT=$(pass ${K8S_PASS_PATH})

KEYCLOAK_ADMIN="$(echo "$OUTPUT" | grep -e "^KEYCLOAK_ADMIN=" | cut -d'=' -f2)"
KEYCLOAK_ADMIN_PASSWORD="$(echo "$OUTPUT" | grep -e "^KEYCLOAK_ADMIN_PASSWORD=" | cut -d'=' -f2)"

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--from-literal=KEYCLOAK_ADMIN="${KEYCLOAK_ADMIN}" \
	--from-literal=KEYCLOAK_ADMIN_PASSWORD="${KEYCLOAK_ADMIN_PASSWORD}" \
	--dry-run=client -o yaml |
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin
