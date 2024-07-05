#!/bin/bash

# Variables de configuración
REGION="us-west-2"
ACCOUNT_ID="338287058401"
REPOSITORY_NAME="laboratorio_mafe"
IMAGE_TAG="latest"
NAMESPACE="lab-mafe-ci-cd"



#!/bin/bash
set -e

# Verifica la disponibilidad de la aplicación en Minikube a través de ngrok
NGROK_URL="https://10ba-186-144-144-107.ngrok-free.app"

# Realiza una solicitud HTTP para verificar la respuesta
if curl --output /dev/null --silent --head --fail "$NGROK_URL"; then
    echo "Validation successful: Application is accessible."
else
    echo "Validation failed: Application is not accessible."
    exit 1
fi


echo "Casa"
export KUBECONFIG=/home/maria-fernanda/.kube/config

# Asegúrate de que el namespace exista
echo "Verificando namespace..."
if kubectl get namespace $NAMESPACE; then
  echo "Namespace $NAMESPACE encontrado."
else
  echo "Namespace $NAMESPACE no encontrado. Creando namespace..."
  if kubectl create namespace $NAMESPACE; then
    echo "Namespace $NAMESPACE creado con éxito."
  else
    echo "Error al crear el namespace $NAMESPACE."
    exit 1
  fi
fi

# Autenticación en ECR y actualización del deployment en Minikube
echo "Logging into Docker..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

if [ $? -ne 0 ]; then
  echo "Failed to login to ECR"
  exit 1
fi

# Actualizar el deployment en Minikube con la nueva imagen
echo "Actualizando imagen..."
kubectl set image deployment/laboratorio-mafe -n $NAMESPACE laboratorio-mafe=$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPOSITORY_NAME:$IMAGE_TAG

if [ $? -ne 0 ]; then
  echo "Failed to set image"
  exit 1
fi

# Aplicar los archivos de configuración de Kubernetes
echo "Aplicando configuración de Kubernetes..."
kubectl apply -f ./deployment.yaml -n $NAMESPACE

if [ $? -ne 0 ]; then
  echo "Failed to apply deployment configuration"
  exit 1
fi

echo "Deployment actualizado y configuración aplicada con éxito."
