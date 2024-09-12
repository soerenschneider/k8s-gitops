#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"
###########################################################

#OUTPUT=$(pass ${K8S_PASS_PATH})

MARIADB_GALERA_MARIABACKUP_USER=backup
MARIADB_GALERA_MARIABACKUP_PASSWORD=blablabla
MARIADB_REPLICATION_USER=replication
MARIADB_REPLICATION_PASSWORD=replication

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--from-literal=MARIADB_GALERA_MARIABACKUP_USER="${MARIADB_GALERA_MARIABACKUP_USER}" \
	--from-literal=MARIADB_GALERA_MARIABACKUP_PASSWORD="${MARIADB_GALERA_MARIABACKUP_PASSWORD}" \
	--from-literal=MARIADB_REPLICATION_USER="${MARIADB_REPLICATION_USER}" \
	--from-literal=MARIADB_REPLICATION_PASSWORD="${MARIADB_REPLICATION_PASSWORD}" \
	--dry-run=client -o yaml |
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin
