#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"
###########################################################

OUTPUT=$(pass ${K8S_PASS_PATH})

DB_USER="$(echo "$OUTPUT" | grep -e "^DB_USER=" | cut -d'=' -f2)"
DB_PWD="$(echo "$OUTPUT" | grep -e "^DB_PWD=" | cut -d'=' -f2)"

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--from-literal=DB_USER="${DB_USER}" \
	--from-literal=DB_PWD="${DB_PWD}" \
	--dry-run=client -o yaml |
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin
