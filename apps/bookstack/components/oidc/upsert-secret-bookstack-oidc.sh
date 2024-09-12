#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"
###########################################################

OIDC_CLIENT_ID="bookstack"
TF_VALUE=$(terraform -chdir=../../../../tf-keycloak output -json clients | jq -r '.["'"${OIDC_CLIENT_ID}"'"]')
OIDC_CLIENT_SECRET=$(echo "$TF_VALUE" | jq -r '.client_secret')

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--from-literal=OIDC_CLIENT_ID="${OIDC_CLIENT_ID}" \
	--from-literal=OIDC_CLIENT_SECRET="${OIDC_CLIENT_SECRET}" \
	--dry-run=client -o yaml |
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin
