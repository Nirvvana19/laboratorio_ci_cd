#!/bin/bash

# Variables
REGION="us-west-2"
ACCOUNT_ID="338287058401"
REPOSITORY_NAME="laboratorio_mafe"
IMAGE_TAG="latest"

# Configura el contexto de Kubernetes para apuntar a Minikube
kubectl config use-context minikube

# Iniciar Minikube
 minikube start

# Autenticarse en ECR
$(aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com)

# Extraer la última imagen de Docker desde ECR
docker pull $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPOSITORY_NAME:$IMAGE_TAG

# Aplicar el despliegue a Minikube
 kubectl apply -f deployment.yaml -n lab-mafe-ci-cd

# Aplicar el despliegue a Minikube
 kubectl apply -f service.yaml -n lab-mafe-ci-cd

# Obtener la URL del servicio
 minikube service laboratorio-mafe-service 

