#!/bin/bash
set -e

# Variables
NAME="devops-api"
USERNAME="sagaryenkure"
IMAGE="$USERNAME/$NAME:latest"

echo "Building Docker image..."
docker build -t "$IMAGE" .

echo "Pushing image to Docker Hub..."
docker push "$IMAGE"

echo "Applying Kubernetes manifests..."
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

echo "Listing all pods..."
kubectl get pods

echo "Listing all services..."
kubectl get services

echo "Fetching main service details..."
kubectl get service "${NAME}-service"

echo "Deployment complete."

echo "Starting the application..."
minikube service "${NAME}-service"