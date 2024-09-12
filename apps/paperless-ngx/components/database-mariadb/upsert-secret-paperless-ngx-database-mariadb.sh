#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"
###########################################################

OUTPUT=$(pass ${K8S_PASS_PATH})

PAPERLESS_DBUSER="$(echo "$OUTPUT" | grep -e "^PAPERLESS_DBUSER=" | cut -d'=' -f2)"
PAPERLESS_DBPASS="$(echo "$OUTPUT" | grep -e "^PAPERLESS_DBPASS=" | cut -d'=' -f2)"

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--from-literal=PAPERLESS_DBUSER="${PAPERLESS_DBUSER}" \
	--from-literal=PAPERLESS_DBPASS="${PAPERLESS_DBPASS}" \
	--dry-run=client -o yaml |
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin