#!/bin/bash

set -euo pipefail

# Check and see if the ingress-nginx chart is installed, if not install it
# helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace

# Wait for the ingress-nginx controller to be ready
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

# Deploy the nginx chart from the helm/charts/nginx directory
helm install demo ./helm/

# Forward local port 8080 to the ingress-nginx controller service
kubectl port-forward --namespace=ingress-nginx service/ingress-nginx-controller 8080:80