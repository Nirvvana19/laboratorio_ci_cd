#!/bin/bash

# Variables de configuración
NAMESPACE="mi-namespace"
IMAGE_TAG="latest"

# Iniciar Ngrok para exponer Minikube
ngrok http 192.168.49.2:30007 &

# Espera unos segundos para que Ngrok esté listo y captura la URL
sleep 10  # Ajusta el tiempo de espera según sea necesario

# Asegúrate de que el namespace exista
kubectl get namespace $NAMESPACE || kubectl create namespace $NAMESPACE

# Autenticación en ECR (si es necesario)
aws ecr get-login-password --region <tu-region> | docker login --username AWS --password-stdin <tu-account-id>.dkr.ecr.<tu-region>.amazonaws.com

# Actualizar el deployment en Minikube
kubectl set image deployment/mi-app-deployment -n $NAMESPACE mi-app-container=<tu-account-id>.dkr.ecr.<tu-region>.amazonaws.com/mi-app:$IMAGE_TAG

# Aplicar archivos de configuración de Kubernetes
kubectl apply -f ./path/to/deployment.yaml -n $NAMESPACE
kubectl apply -f ./path/to/service.yaml -n $NAMESPACE

# Otras acciones necesarias después del despliegue
# ...

# Finalmente, verifica la salida de Ngrok y captura la URL pública generada
NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url')

echo "La aplicación está accesible en: $NGROK_URL"
