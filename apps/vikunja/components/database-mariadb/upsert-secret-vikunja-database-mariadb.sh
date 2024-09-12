#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"
###########################################################

OUTPUT=$(pass ${K8S_PASS_PATH})

VIKUNJA_DATABASE_USER="$(echo "$OUTPUT" | grep -e "^VIKUNJA_DATABASE_USER=" | cut -d'=' -f2)"
VIKUNJA_DATABASE_PASSWORD="$(echo "$OUTPUT" | grep -e "^VIKUNJA_DATABASE_PASSWORD=" | cut -d'=' -f2)"

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--from-literal=VIKUNJA_DATABASE_USER="${VIKUNJA_DATABASE_USER}" \
	--from-literal=VIKUNJA_DATABASE_PASSWORD="${VIKUNJA_DATABASE_PASSWORD}" \
	--dry-run=client -o yaml | 
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin
