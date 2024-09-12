#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"
###########################################################

OAUTH2_PROXY_CLIENT_ID="monitoring"
TF_VALUE=$(terraform -chdir=../../../../../tf-keycloak output -json clients | jq -r '.["'"${OAUTH2_PROXY_CLIENT_ID}"'"]')
OAUTH2_PROXY_CLIENT_SECRET=$(echo "$TF_VALUE" | jq -r '.client_secret')
OAUTH2_PROXY_COOKIE_SECRET="$(openssl rand -base64 32 | tr -- '+/' '-_')"
OAUTH2_PROXY_EMAIL_DOMAINS="*"

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--from-literal=OAUTH2_PROXY_COOKIE_SECRET="${OAUTH2_PROXY_COOKIE_SECRET}" \
	--from-literal=OAUTH2_PROXY_CLIENT_ID="${OAUTH2_PROXY_CLIENT_ID}" \
	--from-literal=OAUTH2_PROXY_CLIENT_SECRET="${OAUTH2_PROXY_CLIENT_SECRET}" \
	--from-literal=OAUTH2_PROXY_EMAIL_DOMAINS="${OAUTH2_PROXY_EMAIL_DOMAINS}" \
	--dry-run=client -o yaml | 
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin