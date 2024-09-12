#!/usr/bin/env bash

CONFIGMAP_NAME="taskd-ca"
CONFIGMAP_KEY="ca.crt"
CONFIGMAP_FILE="configmap-ca.yaml"
DEFAULT_PKI_URL="pki/im_task"

curl -s "${VAULT_ADDR}/v1/${DEFAULT_PKI_URL}/ca/pem" | \
  kubectl create configmap "${CONFIGMAP_NAME}" --from-file="${CONFIGMAP_KEY}"=/dev/stdin --dry-run=client -o yaml > "${CONFIGMAP_FILE}"
