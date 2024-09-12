#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"
###########################################################

OUTPUT=$(pass ${K8S_PASS_PATH})

KC_DB_USERNAME="$(echo "$OUTPUT" | grep -e "^KC_DB_USERNAME=" | cut -d'=' -f2)"
KC_DB_PASSWORD="$(echo "$OUTPUT" | grep -e "^KC_DB_PASSWORD=" | cut -d'=' -f2)"

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--from-literal=KC_DB_USERNAME="${KC_DB_USERNAME}" \
	--from-literal=KC_DB_PASSWORD="${KC_DB_PASSWORD}" \
	--dry-run=client -o yaml |
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin
