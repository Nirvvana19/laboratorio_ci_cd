#!/bin/bash

# Nombre del namespace
NAMESPACE=lab-mafe-ci-cd

# Configura el contexto de Kubernetes para Minikube
kubectl config set-cluster minikube --server=https://192.168.49.2:8443 --insecure-skip-tls-verify
kubectl config set-context minikube --cluster=minikube --namespace=$NAMESPACE
kubectl config use-context minikube

# Asegúrate de que el namespace exista
kubectl get namespace $NAMESPACE || kubectl create namespace $NAMESPACE

# Actualiza el deployment en Minikube con la nueva imagen
kubectl set image deployment/laboratorio-mafe -n $NAMESPACE laboratorio-mafe=338287058401.dkr.ecr.us-west-2.amazonaws.com/laboratorio_mafe:latest
