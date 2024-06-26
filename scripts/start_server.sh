#!/bin/bash

# Autenticarse en ECR
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 338287058401.dkr.ecr.us-east-1.amazonaws.com

# Extraer la última imagen de Docker desde ECR
docker pull 338287058401.dkr.ecr.us-west-2.amazonaws.com/laboratorio_mafe:latest

# Ejecutar la aplicación
docker run -d -p 80:80 --name labo_mafe_aws 338287058401.dkr.ecr.us-west-2.amazonaws.com/laboratorio_mafe:latest
