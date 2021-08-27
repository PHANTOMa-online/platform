#!/usr/bin/env bash

# This script sets up a kubernetes cluster in kind, then installs flux
# and configures it to use the test cluster kustomize overlay against 
# a user specified branch.
# Then, it verifies all workloads come up successfully.

# This script is meant to be run locally to test the entire platform.
# A similar check is also done in CI.

# Prerequisites
# - docker
# - kind v0.11.1

BRANCH=${1:-main}

cleanup() {
    echo "INFO - Deleting KIND cluster"
    kind delete cluster --name phantoma-test
}

trap cleanup EXIT
set -o errexit

echo "INFO - Creating KIND cluster"
kind create cluster --name phantoma-test
CLUSTER=true

echo "INFO - Installing flux"
flux install

echo "INFO - Adding cluster kustomization"
flux create source git flux-system \
  --url=https://github.com/PHANTOMa-online/platform \
  --branch=$BRANCH
kubectl create secret generic sops-gpg \
  --namespace=flux-system \
  --from-file=secrets.test.PHANTOMa.online.asc=$(dirname $0)/../keys/secrets.test.PHANTOMa.online_81EC941E1601C5D9.sec.asc
flux create kustomization flux-system \
  --source=flux-system \
  --path=./clusters/test

echo "INFO - Verifying cluster reconciliation"
`dirname $0`/verify.sh
