#!/usr/bin/env bash

K8S_SECRET_NAME="ghcr-login-secret"
K8S_SECRET_FILE_NAME="sops-secret-ghcr-docker-registry.yaml"
SECRET=""

kubectl create secret docker-registry ghcr-login-secret --docker-server=ghcr.io --docker-username=soerenschneider --docker-password="${SECRET}" --docker-email=my@email.tld --dry-run=client -o yaml |
    sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin
