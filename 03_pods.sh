#!/bin/bash

kubectl get pods
# No resources found in default namespace.

kubectl apply -f pod1.yml 
# pod/nginx created

kubectl get pods
# NAME    READY   STATUS    RESTARTS   AGE
# nginx   1/1     Running   0          6s

kubectl get pods -o wide
# NAME    READY   STATUS    RESTARTS   AGE   IP           NODE       NOMINATED NODE   READINESS GATES
# nginx   1/1     Running   0          44s   172.17.0.5   minikube   <none>           <none>

# `kubectl describe pods nginx` filter pods by name
kubectl describe pods
# Name:         nginx
# Namespace:    default
# Priority:     0
# Node:         minikube/192.168.49.2
# Start Time:   Fri, 01 Jan 2021 23:43:55 -0300
# Labels:       <none>
# Annotations:  <none>
# Status:       Running
# IP:           172.17.0.5
# IPs:
#   IP:  172.17.0.5
# Containers:
#   webserver:
#     Container ID:   docker://820cd59686aa0d7e2a051acae07d2d4e3321b03e14abf36f5a8eb6eb3b8791b3
#     Image:          nginx:latest
#     Image ID:       docker-pullable://nginx@sha256:4cf620a5c81390ee209398ecc18e5fb9dd0f5155cd82adcbae532fec94006fb9
#     Port:           80/TCP
#     Host Port:      0/TCP
#     State:          Running
#       Started:      Fri, 01 Jan 2021 23:43:58 -0300
#     Ready:          True
#     Restart Count:  0
#     Environment:    <none>
#     Mounts:
#       /var/run/secrets/kubernetes.io/serviceaccount from default-token-cdk2f (ro)
# Conditions:
#   Type              Status
#   Initialized       True 
#   Ready             True 
#   ContainersReady   True 
#   PodScheduled      True 
# Volumes:
#   default-token-cdk2f:
#     Type:        Secret (a volume populated by a Secret)
#     SecretName:  default-token-cdk2f
#     Optional:    false
# QoS Class:       BestEffort
# Node-Selectors:  <none>
# Tolerations:     node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
#                  node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
# Events:
#   Type    Reason     Age    From               Message
#   ----    ------     ----   ----               -------
#  Normal  Scheduled  2m23s  default-scheduler  Successfully assigned default/nginx to minikube
#  Normal  Pulling    2m23s  kubelet            Pulling image "nginx:latest"
#  Normal  Pulled     2m20s  kubelet            Successfully pulled image "nginx:latest" in 2.360792105s
#  Normal  Created    2m20s  kubelet            Created container webserver
#  Normal  Started    2m20s  kubelet            Started container webserver

kubectl delete pod nginx
# pod "nginx" deleted

kubectl apply -f pod1.yml 
# pod/nginx created

kubectl delete -f pod1.yml 
# pod "nginx" deleted

kubectl get pods
# No resources found in default namespace.

