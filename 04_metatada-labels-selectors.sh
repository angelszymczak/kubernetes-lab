#!/bin/bash

kubectl apply -f pod2.yml 
# pod/nginx2 created

kubectl get pods
# NAME     READY   STATUS              RESTARTS   AGE
# nginx2   0/1     ContainerCreating   0          9s

kubectl apply -f metadata-nginx.yml 
# pod/nginx created

kubectl get pods
# NAME     READY   STATUS    RESTARTS   AGE
# nginx    1/1     Running   0          3s
# nginx2   1/1     Running   0          2m10s

kubectl describe pod nginx
# Name:         nginx
# Namespace:    default
# Priority:     0
# Node:         minikube/192.168.49.2
# Start Time:   Sat, 02 Jan 2021 00:01:41 -0300
# Labels:       environment=testing
#               project=nginx
# Annotations:  <none>
# Status:       Running
# IP:           172.17.0.6
# IPs:
#   IP:  172.17.0.6
# Containers:
#   nginx:
#     Container ID:   docker://656cdb7ed841eae9b2f8f6e917cf8acfb84a4bbb2ea9910c7151e244d2c55733
#     Image:          nginx:1.7.9
#     Image ID:       docker-pullable://nginx@sha256:e3456c851a152494c3e4ff5fcc26f240206abac0c9d794affb40e0714846c451
#     Port:           80/TCP
#     Host Port:      0/TCP
#     State:          Running
#       Started:      Sat, 02 Jan 2021 00:01:43 -0300
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
#   Normal  Scheduled  2m10s  default-scheduler  Successfully assigned default/nginx to minikube
#   Normal  Pulled     2m10s  kubelet            Container image "nginx:1.7.9" already present on machine
#   Normal  Created    2m9s   kubelet            Created container nginx
#   Normal  Started    2m9s   kubelet            Started container nginx

kubectl get pods --show-labels
# NAME     READY   STATUS    RESTARTS   AGE     LABELS
# nginx    1/1     Running   0          99s     environment=testing,project=nginx
# nginx2   1/1     Running   0          3m46s   <none>

kubectl get pods --selector project=nginx
# NAME    READY   STATUS    RESTARTS   AGE
# nginx   1/1     Running   0          5m13s

kubectl get pods --selector project=nginx --show-labels
# NAME    READY   STATUS    RESTARTS   AGE     LABELS
# nginx   1/1     Running   0          6m29s   environment=testing,project=nginx

kubectl get pods --show-labels -l project
# NAME    READY   STATUS    RESTARTS   AGE     LABELS
# nginx   1/1     Running   0          9m49s   environment=testing,project=nginx

kubectl get pods --show-labels -l environment
# NAME    READY   STATUS    RESTARTS   AGE   LABELS
# nginx   1/1     Running   0          10m   environment=testing,project=nginx

kubectl delete -f pod2.yml -f metadata-nginx.yml 
# pod "nginx2" deleted
# pod "nginx" deleted

