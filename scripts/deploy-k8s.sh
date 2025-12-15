#!/bin/bash

# Kubernetes Deployment Script
# This script deploys the MovieTicket application to Kubernetes

set -e

NAMESPACE="movieticket"
REGISTRY=${DOCKER_REGISTRY:-"your-registry"}
IMAGE_TAG=${IMAGE_TAG:-"latest"}

echo "🚀 Deploying MovieTicket to Kubernetes"
echo "======================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check kubectl
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}❌ kubectl is not installed${NC}"
    exit 1
fi

# Create namespace
echo "Creating namespace..."
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

# Create secrets if they don't exist
if ! kubectl get secret movieticket-secret -n $NAMESPACE &> /dev/null; then
    echo -e "${YELLOW}⚠️  Secret not found. Please create it:${NC}"
    echo "kubectl create secret generic movieticket-secret \\"
    echo "  --from-literal=JWT_SECRET='your-secret-key' \\"
    echo "  --namespace=$NAMESPACE"
    echo ""
    read -p "Press Enter to continue after creating the secret..."
fi

# Update image names in deployment
echo "Updating image references..."
sed -i.bak "s|movieticket-api:latest|${REGISTRY}/movieticket-api:${IMAGE_TAG}|g" k8s/deployment.yaml
sed -i.bak "s|movieticket-frontend:latest|${REGISTRY}/movieticket-frontend:${IMAGE_TAG}|g" k8s/deployment.yaml

# Apply manifests
echo "Applying Kubernetes manifests..."
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secret.yaml
kubectl apply -f k8s/mongo-statefulset.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/hpa.yaml

# Restore original files
mv k8s/deployment.yaml.bak k8s/deployment.yaml 2>/dev/null || true

# Wait for deployments
echo "Waiting for deployments to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/movieticket-api -n $NAMESPACE
kubectl wait --for=condition=available --timeout=300s deployment/movieticket-frontend -n $NAMESPACE

echo ""
echo -e "${GREEN}✅ Deployment complete!${NC}"
echo ""
echo "Check status with:"
echo "  kubectl get pods -n $NAMESPACE"
echo "  kubectl get svc -n $NAMESPACE"
echo ""

