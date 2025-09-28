#!/bin/bash
echo "Deploying EKS MQ Mainframe Bridge..."
kubectl apply -f kubernetes/01-namespace.yaml
kubectl apply -f kubernetes/02-mq-client-config.yaml
echo "Waiting for MQ operator to be ready..."
kubectl wait --for=condition=Ready queuemanager/qm1 -n mq --timeout=300s
echo "Deployment complete!"