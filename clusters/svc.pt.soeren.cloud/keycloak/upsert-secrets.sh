#!/usr/bin/env bash

set -o pipefail
set -eu

SECRET_NAME="$(basename $(pwd))"
SECRET_FILE_NAME="sops-secret-${SECRET_NAME}.yaml"
NAMESPACE="$(basename $(pwd))"
echo "Upserting secret ${SECRET_NAME}"

CLUSTER_NAME="$(git rev-parse --show-prefix | awk -F'/' '{print $2}')"
PASS_PREFIX="k8s/prd/${CLUSTER_NAME}/keycloak"

KEYCLOAK_ADMIN=admin
KEYCLOAK_ADMIN_PASSWORD=admin
KC_DB_USERNAME=keycloak
KC_DB_PASSWORD=keycloak_password

kubectl create secret generic "${SECRET_NAME}" \
	--namespace="${NAMESPACE}" \
	--from-literal=KEYCLOAK_ADMIN="${KEYCLOAK_ADMIN}" \
	--from-literal=KEYCLOAK_ADMIN_PASSWORD="${KEYCLOAK_ADMIN_PASSWORD}" \
	--from-literal=KC_DB_USERNAME="${KC_DB_USERNAME}" \
	--from-literal=KC_DB_PASSWORD="${KC_DB_PASSWORD}" \
	--dry-run=client -o yaml | 
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${SECRET_FILE_NAME}" /dev/stdin 
