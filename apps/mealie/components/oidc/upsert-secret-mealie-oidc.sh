#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"
###########################################################

OIDC_CLIENT_ID=mealie
TF_VALUE=$(terraform -chdir="$(git rev-parse --show-toplevel)/../tf-keycloak" output -json clients | jq -r '.["'"${OAUTH2_PROXY_CLIENT_ID}"'"]')
OAUTH2_CLIENT_SECRET=$(echo "$TF_VALUE" | jq -r '.client_secret')

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--from-literal=OIDC_CLIENT_ID="${OIDC_CLIENT_ID}" \
	--from-literal=OAUTH2_CLIENT_SECRET="${OAUTH2_CLIENT_SECRET}" \
	--dry-run=client -o yaml |
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin
