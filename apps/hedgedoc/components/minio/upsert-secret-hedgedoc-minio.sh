#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"
###########################################################

OUTPUT=$(pass ${K8S_PASS_PATH})

CMD_MINIO_ACCESS_KEY="$(echo "$OUTPUT" | grep -e "^CMD_MINIO_ACCESS_KEY=" | cut -d'=' -f2)"
CMD_MINIO_SECRET_KEY="$(echo "$OUTPUT" | grep -e "^CMD_MINIO_SECRET_KEY=" | cut -d'=' -f2)"

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--from-literal=CMD_MINIO_ACCESS_KEY="${CMD_MINIO_ACCESS_KEY}" \
	--from-literal=CMD_MINIO_SECRET_KEY="${CMD_MINIO_SECRET_KEY}" \
	--dry-run=client -o yaml |
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin
