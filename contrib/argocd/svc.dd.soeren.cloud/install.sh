#!/usr/bin/env sh

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

kubectl create namespace argocd
kubectl create secret generic argocd-secret \
    --from-literal=server.secretkey=$(openssl rand -base64 32) \
    --namespace=argocd

kubectl apply -k "${SCRIPT_DIR}"
kubectl apply -k "${SCRIPT_DIR}"
