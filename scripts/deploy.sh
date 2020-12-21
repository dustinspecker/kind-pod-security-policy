#!/bin/bash
set -exo pipefail

KIND_CLUSTER_NAME="${KIND_CLUSTER_NAME:-pod-security-policy}"

if [ "$(kind get clusters | grep --count "${KIND_CLUSTER_NAME}")" -eq 0 ]; then
  kind create cluster \
    --config config/kind.yaml \
    --name "${KIND_CLUSTER_NAME}" \
    --retain
fi

kubectl apply \
  --filename deploy/

kubectl wait node "${KIND_CLUSTER_NAME}-control-plane" \
  --for condition=Ready \
  --timeout 5m
