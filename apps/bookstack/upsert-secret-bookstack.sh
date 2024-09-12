#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"
###########################################################

OUTPUT=$(pass ${K8S_PASS_PATH})

# php artisan key:generate
APP_KEY="$(echo "$OUTPUT" | grep -e "^APP_KEY=" | cut -d'=' -f2)"
DB_USERNAME="$(echo "$OUTPUT" | grep -e "^DB_USERNAME=" | cut -d'=' -f2)"
DB_PASSWORD="$(echo "$OUTPUT" | grep -e "^DB_PASSWORD=" | cut -d'=' -f2)"

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--from-literal=APP_KEY="${APP_KEY}" \
	--from-literal=DB_USERNAME="${DB_USERNAME}" \
	--from-literal=DB_PASSWORD="${DB_PASSWORD}" \
	--dry-run=client -o yaml |
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin