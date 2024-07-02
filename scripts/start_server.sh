#!/bin/bash

# Variables
REGION="us-west-2"
ACCOUNT_ID="338287058401"
REPOSITORY_NAME="laboratorio_mafe"
IMAGE_TAG="latest"
NAMESPACE="lab-mafe-ci-cd"

# Configura el contexto de Kubernetes para apuntar a Minikube
kubectl config use-context minikube

# Iniciar Minikube con el controlador none y cri-dockerd
minikube start 

# Autenticarse en ECR
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# Extraer la última imagen de Docker desde ECR
docker pull $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPOSITORY_NAME:$IMAGE_TAG

kubectl create namespace $NAMESPACE

# Aplicar el despliegue a Minikube
kubectl apply -f /home/ubuntu/laboratorio_ci_cd/deployment.yaml -n $NAMESPACE

# Aplicar el servicio a Minikube
kubectl apply -f /home/ubuntu/laboratorio_ci_cd/service.yaml -n $NAMESPACE

# Obtener la URL del servicio
minikube service laboratorio-mafe-service -n $NAMESPACE
