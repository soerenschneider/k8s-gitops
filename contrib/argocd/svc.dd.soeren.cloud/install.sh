#!/usr/bin/env sh

kubectl create secret generic argocd-secret \
    --from-literal=server.secretkey=$(openssl rand -base64 32) \
    --namespace=argocd
