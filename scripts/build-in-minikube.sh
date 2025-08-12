#!/usr/bin/env bash
set -euo pipefail

# Folders containing Dockerfiles
BACKEND_DIR="../backend"
FRONTEND_DIR="../frontend"

# Tags referenced by OpenTofu
BACKEND_IMG="backend:local"
FRONTEND_IMG="frontend:local"

echo ">> Switching Docker context to Minikube’s internal daemon"
eval "$(minikube docker-env)"

echo ">> Building BACKEND image ($BACKEND_IMG)"
docker build -t "$BACKEND_IMG" "$BACKEND_DIR"
minikube image build -t "$BACKEND_IMG" ./backend


echo ">> Building FRONTEND image ($FRONTEND_IMG)"
docker build -t "$FRONTEND_IMG" "$FRONTEND_DIR"
minikube image build -t "$FRONTEND_IMG" ./fronend


echo ">> Images now stored inside the Minikube VM:"
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | grep -E 'backend|frontend'

echo ">> Restoring host Docker context"
eval "$(minikube docker-env -u)"

echo "✅  Ready to reference in OpenTofu:"
echo "   backend_image  = \"${BACKEND_IMG}\""
echo "   frontend_image = \"${FRONTEND_IMG}\""
