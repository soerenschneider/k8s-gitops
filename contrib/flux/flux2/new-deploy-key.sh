#!/bin/sh

NAMESPACE="flux-system"
if ! kubectl get namespace "${NAMESPACE}"; then
    kubectl create ns "${NAMESPACE}"
fi

if kubectl get secret -n flux-system deploy-keys 2> /dev/null > /dev/null; then
    echo "This is cluster \"$(kubectl config current-context)\""
    echo "You've already have a deploy key defined. This option will overwrite it, meaning you'll have to add it to your github repo again!"
    read -p "Do you want to proceed? (y/N): " choice

    if [[ "${choice}" != [Yy] ]]; then
        exit 0
    fi
fi

flux create secret git deploy-keys --ssh-key-algorithm=ed25519 --url=ssh://git@github.com/soerenschneider/k8s-gitops
