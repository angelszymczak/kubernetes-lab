#!/bin/bash

kubectl get all
# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   31h

# Manage Cluster changes through Manifest file
kubectl apply -f deployment-sample.yml 
# Unable to connect to the server: dial tcp 192.168.49.2:8443: connect: no route to host

minikube start
# 😄  minikube v1.16.0 on Ubuntu 18.04
# ✨  Using the docker driver based on existing profile
# 👍  Starting control plane node minikube in cluster minikube
# 🔄  Restarting existing docker container for "minikube" ...
# 🐳  Preparing Kubernetes v1.20.0 on Docker 20.10.0 ...
# 🔎  Verifying Kubernetes components...
# 🌟  Enabled addons: storage-provisioner, default-storageclass, dashboard
# 🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default

kubectl apply -f deployment-sample.yml 
# deployment.apps/nginx-deployment created

kubectl get all
# NAME                                   READY   STATUS    RESTARTS   AGE
# pod/nginx-deployment-585449566-w9hgj   1/1     Running   0          19s
# 
# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   31h
# 
# NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/nginx-deployment   1/1     1            1           22s
# 
# NAME                                         DESIRED   CURRENT   READY   AGE
# replicaset.apps/nginx-deployment-585449566   1         1         1       19s

# To delete created resource through Manifest file
kubectl delete -f deployment-sample.yml 
# deployment.apps "nginx-deployment" deleted

kubectl get all
# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   31h

