#!/bin/bash

kubectl apply -f pod-replication-controller.yml 
replicationcontroller/nginx-testing created

kubectl get pods
# NAME                  READY   STATUS    RESTARTS   AGE
# nginx-testing-98gbq   1/1     Running   0          14s
# nginx-testing-hjvrb   1/1     Running   0          14s

# Since now the ReplicationController generates Pods with hashed names,
# we can no longer refer to that Pod through names, so it will be useful to manage them through labels.
kubectl get pods --show-labels
# NAME                  READY   STATUS    RESTARTS   AGE     LABELS
# nginx-testing-98gbq   1/1     Running   0          2m51s   environment=testing,project=nginx
# nginx-testing-hjvrb   1/1     Running   0          2m51s   environment=testing,project=nginx

kubectl get all
# NAME                      READY   STATUS    RESTARTS   AGE
# pod/nginx-testing-98gbq   1/1     Running   0          3m8s
# pod/nginx-testing-hjvrb   1/1     Running   0          3m8s
# 
# NAME                                  DESIRED   CURRENT   READY   AGE
# replicationcontroller/nginx-testing   2         2         2       3m8s
# 
# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   33h

kubectl apply -f pod-replication-controller.yml 
# replicationcontroller/nginx-testing configured

kubectl get all
# NAME                      READY   STATUS              RESTARTS   AGE
# pod/nginx-testing-64bf7   0/1     ContainerCreating   0          4s
# pod/nginx-testing-98gbq   1/1     Running             0          6m3s
# pod/nginx-testing-hjvrb   1/1     Running             0          6m3s
#
# NAME                                  DESIRED   CURRENT   READY   AGE
# replicationcontroller/nginx-testing   3         3         2       6m3s
# 
# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   33h

kubectl get rc
# NAME            DESIRED   CURRENT   READY   AGE
# nginx-testing   2         2         2       8m50s

kubectl get replicationcontroller
# NAME            DESIRED   CURRENT   READY   AGE
# nginx-testing   2         2         2       8m58s

kubectl describe rc nginx-testing
# Name:         nginx-testing
# Namespace:    default
# Selector:     environment=testing,project=nginx
# Labels:       environment=testing
#               project=nginx
# Annotations:  <none>
# Replicas:     2 current / 2 desired
# Pods Status:  2 Running / 0 Waiting / 0 Succeeded / 0 Failed
# Pod Template:
#   Labels:  environment=testing
#            project=nginx
#   Containers:
#    nginx:
#     Image:        nginx
#     Port:         80/TCP
#     Host Port:    0/TCP
#     Environment:  <none>
#     Mounts:       <none>
#   Volumes:        <none>
# Events:
#   Type    Reason            Age    From                    Message
#   ----    ------            ----   ----                    -------
#   Normal  SuccessfulCreate  9m32s  replication-controller  Created pod: nginx-testing-98gbq
#   Normal  SuccessfulCreate  9m32s  replication-controller  Created pod: nginx-testing-hjvrb
#   Normal  SuccessfulCreate  3m33s  replication-controller  Created pod: nginx-testing-64bf7
#   Normal  SuccessfulDelete  2m9s   replication-controller  Deleted pod: nginx-testing-64bf7

kubectl get pod,rc
# NAME                      READY   STATUS    RESTARTS   AGE
# pod/nginx-testing-98gbq   1/1     Running   0          10m
# pod/nginx-testing-hjvrb   1/1     Running   0          10m
#
# NAME                                  DESIRED   CURRENT   READY   AGE
# replicationcontroller/nginx-testing   2         2         2       10m

kubectl delete -f pod-replication-controller.yml 
# replicationcontroller "nginx-testing" deleted

kubectl get pod,rc
# NAME                      READY   STATUS        RESTARTS   AGE
# pod/nginx-testing-98gbq   1/1     Terminating   0          11m
# pod/nginx-testing-hjvrb   1/1     Terminating   0          11m

kubectl get pod,rc
# No resources found in default namespace.

kubectl apply -f pod-replication-controller.yml 
# replicationcontroller/nginx-testing created

kubectl get pod,rc
# NAME                      READY   STATUS    RESTARTS   AGE
# pod/nginx-testing-97mvs   1/1     Running   0          3m44s
# pod/nginx-testing-h67v7   1/1     Running   0          3m44s
# pod/nginx-testing-zcc5t   1/1     Running   0          3m44s
# 
# NAME                                  DESIRED   CURRENT   READY   AGE
# replicationcontroller/nginx-testing   3         3         3       3m44s

kubectl delete rc nginx-testing --cascade=orphan
# replicationcontroller "nginx-testing" deleted

kubectl get rc
# No resources found in default namespace.

kubectl get pod,rc
# NAME                      READY   STATUS    RESTARTS   AGE
# pod/nginx-testing-97mvs   1/1     Running   0          7m25s
# pod/nginx-testing-h67v7   1/1     Running   0          7m25s
# pod/nginx-testing-zcc5t   1/1     Running   0          7m25s

kubectl apply -f pod-replication-controller.yml 
# replicationcontroller/nginx-testing created

kubectl get pod,rc
# NAME                      READY   STATUS    RESTARTS   AGE
# pod/nginx-testing-97mvs   1/1     Running   0          9m54s
# pod/nginx-testing-h67v7   1/1     Running   0          9m54s
# pod/nginx-testing-zcc5t   1/1     Running   0          9m54s
# 
# NAME                                  DESIRED   CURRENT   READY   AGE
# replicationcontroller/nginx-testing   3         3         3       1s

kubectl delete -f pod-replication-controller.yml 
# replicationcontroller "nginx-testing" deleted

kubectl get pod,rc
# NAME                      READY   STATUS        RESTARTS   AGE
# pod/nginx-testing-97mvs   0/1     Terminating   0          10m
# pod/nginx-testing-h67v7   0/1     Terminating   0          10m
# pod/nginx-testing-zcc5t   0/1     Terminating   0          10m
