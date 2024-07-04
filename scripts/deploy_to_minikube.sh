#!/bin/bash

# Variables de configuración
REGION="us-west-2"
ACCOUNT_ID="338287058401"
REPOSITORY_NAME="laboratorio_mafe"
IMAGE_TAG="latest"
NAMESPACE="lab-mafe-ci-cd"
NGROK_URL="http://abcd1234.ngrok.io"  # Reemplaza con tu URL de Ngrok

# Asegúrate de que el namespace exista en Minikube
echo "Verificando namespace en Minikube..."
if kubectl get namespace $NAMESPACE &> /dev/null; then
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
echo "Iniciando sesión en Docker..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

if [ $? -ne 0 ]; then
  echo "Error al iniciar sesión en ECR"
  exit 1
fi

# Actualizar el deployment en Minikube con la nueva imagen y la URL de Ngrok
echo "Actualizando imagen y URL en Minikube..."
kubectl set image deployment/laboratorio-mafe -n $NAMESPACE laboratorio-mafe=$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPOSITORY_NAME:$IMAGE_TAG

# Actualizar el servicio para usar la URL de Ngrok
sed -i "s|NGROK_URL_PLACEHOLDER|$NGROK_URL|g" ./service.yaml
kubectl apply -f ./service.yaml -n $NAMESPACE

# Aplicar los archivos de configuración de Kubernetes
echo "Aplicando configuración de Kubernetes..."
kubectl apply -f ./deployment.yaml -n $NAMESPACE

if [ $? -ne 0 ]; then
  echo "Error al aplicar la configuración de deployment"
  exit 1
fi

echo "Despliegue actualizado y configuración aplicada con éxito."
