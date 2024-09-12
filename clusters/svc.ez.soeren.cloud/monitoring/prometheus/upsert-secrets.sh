#!/usr/bin/env bash

set -o pipefail
set -eu

SECRET_NAME="oauth2-proxy"
SECRET_FILE_NAME="sops-secret-${SECRET_NAME}.yaml"
echo "Upserting secret ${SECRET_NAME}"

OAUTH2_PROXY_CLIENT_ID="prometheus"
TF_VALUE=$(terraform -chdir=../../../../../tf-keycloak output -json clients | jq -r '.["'"${OAUTH2_PROXY_CLIENT_ID}"'"]')
OAUTH2_PROXY_CLIENT_SECRET=$(echo "$TF_VALUE" | jq -r '.client_secret')
OAUTH2_PROXY_COOKIE_SECRET="$(openssl rand -base64 32 | tr -- '+/' '-_')"
OAUTH2_PROXY_EMAIL_DOMAINS="*"

kubectl create secret generic "${SECRET_NAME}" \
	--from-literal=OAUTH2_PROXY_COOKIE_SECRET="${OAUTH2_PROXY_COOKIE_SECRET}" \
	--from-literal=OAUTH2_PROXY_CLIENT_ID="${OAUTH2_PROXY_CLIENT_ID}" \
	--from-literal=OAUTH2_PROXY_CLIENT_SECRET="${OAUTH2_PROXY_CLIENT_SECRET}" \
	--from-literal=OAUTH2_PROXY_EMAIL_DOMAINS="${OAUTH2_PROXY_EMAIL_DOMAINS}" \
	--dry-run=client -o yaml | 
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${SECRET_FILE_NAME}" /dev/stdin