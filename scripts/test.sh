#!/usr/bin/env bash

# This script sets up a kubernetes cluster in kind, then installs flux
# and configures it to use the test cluster kustomize overlay.
# Then, it verifies all workloads come up successfully.

# This script is meant to be run locally to test the entire platform.
# A similar check is also done in CI.

# Prerequisites
# - docker
# - kind v0.11.1

cleanup() {
    echo "INFO - Deleting KIND cluster"
    kind delete cluster --name phantoma-test
}

trap cleanup ERR EXIT
set -o errexit

echo "INFO - Creating KIND cluster"
kind create cluster --name phantoma-test
CLUSTER=true

echo "INFO - Installing flux"
flux install

echo "INFO - Adding cluster kustomization"
flux create source git flux-system \
  --url=https://github.com/PHANTOMa-online/platform \
  --branch=main
flux create kustomization flux-system \
  --source=flux-system \
  --path=./clusters/test

echo "INFO - Verifying cluster reconciliation"
`dirname $0`/verify.sh
