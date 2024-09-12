#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"
###########################################################

# manually overriden
K8S_PASS_PATH="infra/dyndns/common/prod/aws-endpoints"

OUTPUT=$(pass ${K8S_PASS_PATH})

DYNDNS_SQS_QUEUE="$(echo "$OUTPUT" | grep -e "^DYNDNS_SQS_QUEUE=" | cut -d'=' -f2)"
DYNDNS_HTTP_RESOLVER_PREFERRED_URLS="$(echo "$OUTPUT" | grep -e "^DYNDNS_HTTP_RESOLVER_PREFERRED_URLS=" | cut -d'=' -f2)"
DYNDNS_HTTP_DISPATCHER_CONF="$(echo "$OUTPUT" | grep -e "^DYNDNS_HTTP_DISPATCHER_CONF=" | cut -d'=' -f2)"

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--from-literal=DYNDNS_SQS_QUEUE="${DYNDNS_SQS_QUEUE}" \
	--from-literal=DYNDNS_HTTP_RESOLVER_PREFERRED_URLS="${DYNDNS_HTTP_RESOLVER_PREFERRED_URLS}" \
	--from-literal=DYNDNS_HTTP_DISPATCHER_CONF="${DYNDNS_HTTP_DISPATCHER_CONF}" \
	--dry-run=client -o yaml |
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin