#!/bin/bash

# Aplicar los archivos de configuración de Kubernetes
kubectl apply -f /home/ec2-user/laboratorio_ci_cd/deployment.yml
kubectl apply -f /home/ec2-user/laboratorio_ci_cd/service.yml
