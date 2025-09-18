#!/bin/bash

# Configuration
IMAGE_NAME="ghcr.io/mojimbo80/my-app"
IMAGE_TAG="latest" # ou le SHA du dernier commit si vous l'utilisez
DEPLOYMENT_FILE="deployment.yml"

# Assurez-vous que minikube est en cours d'exécution
minikube start --driver=docker

# Configure l'environnement Docker pour minikube et pull l'image
eval $(minikube docker-env)
docker pull $IMAGE_NAME:$IMAGE_TAG

# Mettez à jour le fichier de déploiement avec le bon tag d'image
# Nous utilisons 'sed' pour cela, c'est une méthode simple mais efficace.
sed -i "s|image: .*|image: $IMAGE_NAME:$IMAGE_TAG|" $DEPLOYMENT_FILE

# Appliquez le déploiement
echo "Déploiement de l'application avec $DEPLOYMENT_FILE"
kubectl apply -f $DEPLOYMENT_FILE

# Affichez l'URL de l'application
echo "Déploiement terminé. Pour accéder à votre application, exécutez :"
echo "minikube service mon-app-service"
