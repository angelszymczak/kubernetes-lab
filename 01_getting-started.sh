#!/bin/bash

kubectl get nodes
# NAME       STATUS   ROLES                  AGE   VERSION
# minikube   Ready    control-plane,master   30h   v1.20.0

# Indifferent access singular or plural
kubectl get node
# NAME       STATUS   ROLES                  AGE   VERSION
# minikube   Ready    control-plane,master   30h   v1.20.0

# Filtering
kubectl get node minikube
# NAME       STATUS   ROLES                  AGE   VERSION
# minikube   Ready    control-plane,master   30h   v1.20.0

# More detailed info
kubectl get nodes -o wide
# NAME       STATUS   ROLES                  AGE   VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
# minikube   Ready    control-plane,master   30h   v1.20.0   192.168.49.2   <none>        Ubuntu 20.04.1 LTS   5.4.0-58-generic   docker://20.10.0

# Full description
kubectl get nodes -o json

