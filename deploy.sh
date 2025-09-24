#!/bin/bash
set -e

# Variables
NAME="devops-api"
USERNAME="sagaryenkure"
IMAGE="$USERNAME/$NAME:latest"

echo "Checking for existing Docker image..."
if docker images --format "{{.Repository}}:{{.Tag}}" | grep -q "$IMAGE"; then
  echo "Image $IMAGE exists. Removing..."
  docker rmi -f "$IMAGE"
else
  echo "No existing image found for $IMAGE"
fi

echo "Building Docker image..."
docker build -t "$IMAGE" .

echo "Pushing image to Docker Hub..."
docker push "$IMAGE"

echo "Applying Kubernetes manifests..."
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# Force Kubernetes to redeploy pods using the new image
echo "Restarting deployment to use new image..."
kubectl rollout restart deployment "$NAME"

# Wait for pods to be ready
echo "Waiting for pods to be ready..."
kubectl rollout status deployment "$NAME"

echo "Listing all pods..."
kubectl get pods

echo "Listing all services..."
kubectl get services

echo "Fetching main service details..."
kubectl get service "${NAME}-service"

echo "Deployment complete."

# Optional: open service in minikube
echo "Starting the application in minikube..."
minikube service "${NAME}-service"
