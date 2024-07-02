#!/bin/bash

# Variables
REGION="us-west-2"
ACCOUNT_ID="338287058401"
REPOSITORY_NAME="laboratorio_mafe"
IMAGE_TAG="latest"


# Iniciar Minikube
# minikube start

# Iniciar Docker dentro de Minikube
# eval $(minikube docker-env)

# Autenticarse en ECR
$(aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com)

# Extraer la última imagen de Docker desde ECR
docker pull $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPOSITORY_NAME:$IMAGE_TAG


# Cargar la imagen en Minikube
# minikube image load $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPOSITORY:$IMAGE_TAG

# Aplicar el despliegue a Minikube
# kubectl apply -f $DEPLOYMENT_FILE

# Aplicar el despliegue a Minikube
# kubectl apply -f $SERVICE_FILE

# Obtener la URL del servicio
# minikube service laboratorio-mafe-service 

