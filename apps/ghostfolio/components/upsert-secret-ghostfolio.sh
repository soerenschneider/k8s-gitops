#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"
###########################################################

OUTPUT=$(pass ${K8S_PASS_PATH})

DATABASE_URL="$(echo "$OUTPUT" | grep -e "^DATABASE_URL=" | cut -d'=' -f2)"
JWT_SECRET_KEY="$(echo "$OUTPUT" | grep -e "^JWT_SECRET_KEY=" | cut -d'=' -f2)"
SECRET_KEY="$(echo "$OUTPUT" | grep -e "^SECRET_KEY=" | cut -d'=' -f2)"

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--from-literal=DATABASE_URL="${DATABASE_URL}" \
	--from-literal=JWT_SECRET_KEY="${JWT_SECRET_KEY}" \
	--from-literal=SECRET_KEY="${SECRET_KEY}" \
	--dry-run=client -o yaml |
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin
