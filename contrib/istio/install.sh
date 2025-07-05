#!/usr/bin/env bash

cluster=$1
operator=istio-operator-$cluster.yaml
if ! [[ -f $operator ]]; then
    echo "no such file: $operator"
    exit 1
fi

istioctl install -f "${operator}"
