#!/usr/bin/env bash
set -euo pipefail

# Create or ensure namespaces for infrastructure and applications and apply deployments.
# Requirements: minikube, kubectl, opentofu, helm

INFRA_NS="infra"
APP_NS="apps"

# Start a local cluster if one is not running
if ! minikube status >/dev/null 2>&1; then
  echo "Starting Minikube cluster..."
  minikube start
fi

# Create namespaces if they do not exist
kubectl get namespace "$INFRA_NS" >/dev/null 2>&1 || kubectl create namespace "$INFRA_NS"
kubectl get namespace "$APP_NS" >/dev/null 2>&1 || kubectl create namespace "$APP_NS"

# Apply infrastructure with OpenTofu
if [ -d "infrastructure" ]; then
  pushd infrastructure >/dev/null
  tofu init
  tofu apply -var="namespace=${INFRA_NS}" -auto-approve
  popd >/dev/null
else
  echo "No infrastructure directory found; skipping OpenTofu apply"
fi

# Deploy application with Helm
if [ -d "helm" ]; then
  helm upgrade --install app-release helm/app-chart --namespace "$APP_NS" --create-namespace
else
  echo "No Helm chart directory found; skipping Helm deployment"
fi
