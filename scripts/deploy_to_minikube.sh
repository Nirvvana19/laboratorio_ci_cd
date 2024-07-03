#!/bin/bash

# Nombre del namespace
REGION="us-west-2"
ACCOUNT_ID="338287058401"
REPOSITORY_NAME="laboratorio_mafe"
IMAGE_TAG="latest"
NAMESPACE="lab-mafe-ci-cd"

# Configura el contexto de Kubernetes para Minikube
echo "Configuring kubectl to use Minikube..."
export KUBECONFIG=/root/.kube/config
kubectl config set-cluster minikube --server=https://192.168.49.2:8443 --insecure-skip-tls-verify
kubectl config set-context minikube --cluster=minikube --namespace=$NAMESPACE
kubectl config use-context minikube

# Asegúrate de que el namespace exista
echo "Ver namespace"
kubectl get namespace $NAMESPACE || kubectl create namespace $NAMESPACE

# Autenticación en ECR y actualización del deployment en Minikube
echo "Logging into Docker..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com


# Actualiza el deployment en Minikube con la nueva imagen
echo "Actualizar imagen"
kubectl set image deployment/laboratorio-mafe -n $NAMESPACE laboratorio-mafe=338287058401.dkr.ecr.us-west-2.amazonaws.com/laboratorio_mafe:latest

echo "Agregar"
kubectl apply -f ./deployment.yaml -n $NAMESPACE

echo "Agregar"
kubectl apply -f ./service.yaml -n $NAMESPACE
