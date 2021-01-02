#!/bin/bash

kubectl apply -f replicaset.yml 
# replicaset.apps/nginx-testing created <=

kubectl get pods,rs
# NAME                      READY   STATUS    RESTARTS   AGE
# pod/nginx-testing-pfc28   1/1     Running   0          36s
# pod/nginx-testing-xjcp2   1/1     Running   0          36s
#
# NAME                            DESIRED   CURRENT   READY   AGE
# replicaset.apps/nginx-testing   2         2         2       36s

# Mofidy replica property to 5
kubectl apply -f replicaset.yml 
# replicaset.apps/nginx-testing configured <=

kubectl get pods,rs
# NAME                      READY   STATUS              RESTARTS   AGE
# pod/nginx-testing-4c27k   0/1     ContainerCreating   0          2s
# pod/nginx-testing-fgfjt   0/1     ContainerCreating   0          2s
# pod/nginx-testing-hzzzr   0/1     ContainerCreating   0          2s
# pod/nginx-testing-pfc28   1/1     Running             0          71s
# pod/nginx-testing-xjcp2   1/1     Running             0          71s
# 
# NAME                            DESIRED   CURRENT   READY   AGE
# replicaset.apps/nginx-testing   5         5         2       71s

kubectl delete -f replicaset.yml 
# replicaset.apps "nginx-testing" deleted

kubectl get pods,rs
# NAME                      READY   STATUS        RESTARTS   AGE
# pod/nginx-testing-4c27k   0/1     Terminating   0          3m39s
# pod/nginx-testing-fgfjt   0/1     Terminating   0          3m39s
# pod/nginx-testing-hzzzr   0/1     Terminating   0          3m39s
# pod/nginx-testing-pfc28   0/1     Terminating   0          4m48s
# pod/nginx-testing-xjcp2   0/1     Terminating   0          4m48s

kubectl get pods,rs
# No resources found in default namespace.

kubectl apply -f replicaset-matchexpressions.yml 
# replicaset.apps/frontend created

kubectl get pods,rs
# NAME                 READY   STATUS              RESTARTS   AGE
# pod/frontend-nz98p   0/1     ContainerCreating   0          3s
# pod/frontend-rfqb9   0/1     ContainerCreating   0          3s
# 
# NAME                       DESIRED   CURRENT   READY   AGE
# replicaset.apps/frontend   2         2         0       3s

kubectl delete -f replicaset-matchexpressions.yml 
# replicaset.apps "frontend" deleted

kubectl get pods,rs
# NAME                 READY   STATUS        RESTARTS   AGE
# pod/frontend-nz98p   0/1     Terminating   0          14s
# pod/frontend-rfqb9   0/1     Terminating   0          14s

