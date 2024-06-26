#!/bin/bash

# Variables
REGION="us-west-2"
ACCOUNT_ID="338287058401"
REPOSITORY_NAME="laboratorio_mafe"
IMAGE_TAG="latest"

# Autenticarse en ECR
$(aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com)

# Extraer la última imagen de Docker desde ECR
docker pull $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPOSITORY_NAME:$IMAGE_TAG

# Ejecutar la aplicación
docker run -d -p 80:80 $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPOSITORY_NAME:$IMAGE_TAG
