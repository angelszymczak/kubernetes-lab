#!/bin/bash

kubectl apply -f replicaset-clusterip.yml 
# replicaset.apps/nginx-testing-clusterip created

kubectl get all -o wide --show-labels
# NAME                                READY   STATUS    RESTARTS   AGE   IP           NODE       NOMINATED NODE   READINESS GATES   LABELS
# pod/nginx-testing-clusterip-65jrn   1/1     Running   0          14s   172.17.0.5   minikube   <none>           <none>            app=nginx,environment=testing-clusterip
# pod/nginx-testing-clusterip-tc9vg   1/1     Running   0          14s   172.17.0.6   minikube   <none>           <none>            app=nginx,environment=testing-clusterip
# 
# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE   SELECTOR   LABELS
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   44h   <none>     component=apiserver,provider=kubernetes
# 
# NAME                                      DESIRED   CURRENT   READY   AGE   CONTAINERS   IMAGES   SELECTOR                                  LABELS
# replicaset.apps/nginx-testing-clusterip   2         2         2       14s   nginx        nginx    app=nginx,environment=testing-clusterip

kubectl apply -f service-clusterip.yml 
# service/service-clusterip created

kubectl get all --show-labels
# NAME                                READY   STATUS    RESTARTS   AGE   LABELS
# pod/nginx-testing-clusterip-65jrn   1/1     Running   0          24m   app=nginx,environment=testing-clusterip
# pod/nginx-testing-clusterip-tc9vg   1/1     Running   0          24m   app=nginx,environment=testing-clusterip
# 
# NAME                        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE   LABELS
# service/kubernetes          ClusterIP   10.96.0.1       <none>        443/TCP    45h   component=apiserver,provider=kubernetes
# service/service-clusterip   ClusterIP   10.109.40.235   <none>        8080/TCP   3s    <none>
# 
# NAME                                      DESIRED   CURRENT   READY   AGE   LABELS
# replicaset.apps/nginx-testing-clusterip   2         2         2       24m   <none>

# Timeout
curl 10.109.40.235:8080

kubectl exec -it pod/nginx-testing-clusterip-65jrn -- bash
curl 10.109.40.235:8080
# <!DOCTYPE html>
# <html>
# <head>
# <title>Welcome to nginx!</title>
# <style>
#     body {
#         width: 35em;
#         margin: 0 auto;
#         font-family: Tahoma, Verdana, Arial, sans-serif;
#     }
# </style>
# </head>
# <body>
# <h1>Welcome to nginx!</h1>
# <p>If you see this page, the nginx web server is successfully installed and
# working. Further configuration is required.</p>
# 
# <p>For online documentation and support please refer to
# <a href="http://nginx.org/">nginx.org</a>.<br/>
# Commercial support is available at
# <a href="http://nginx.com/">nginx.com</a>.</p>
# 
# <p><em>Thank you for using nginx.</em></p>
# </body>
# </html>
exit

kubectl exec -it pod/nginx-testing-clusterip-65jrn -- bash
curl 10.109.40.235:8080
# <!DOCTYPE html>
# <html>
# <head>
# <title>Welcome to nginx!</title>
# <style>
#     body {
#         width: 35em;
#         margin: 0 auto;
#         font-family: Tahoma, Verdana, Arial, sans-serif;
#     }
# </style>
# </head>
# <body>
# <h1>Welcome to nginx!</h1>
# <p>If you see this page, the nginx web server is successfully installed and
# working. Further configuration is required.</p>
# 
# <p>For online documentation and support please refer to
# <a href="http://nginx.org/">nginx.org</a>.<br/>
# Commercial support is available at
# <a href="http://nginx.com/">nginx.com</a>.</p>
# 
# <p><em>Thank you for using nginx.</em></p>
# </body>
# </html>

# # If our service has a solvable name inside our cluster, then we can also acccess on this way 
curl service-clusterip:8080
# <!DOCTYPE html>
# <html>
# <head>
# <title>Welcome to nginx!</title>
# <style>
#     body {
#         width: 35em;
#         margin: 0 auto;
#         font-family: Tahoma, Verdana, Arial, sans-serif;
#     }
# </style>
# </head>
# <body>
# <h1>Welcome to nginx!</h1>
# <p>If you see this page, the nginx web server is successfully installed and
# working. Further configuration is required.</p>
# 
# <p>For online documentation and support please refer to
# <a href="http://nginx.org/">nginx.org</a>.<br/>
# Commercial support is available at
# <a href="http://nginx.com/">nginx.com</a>.</p>
# 
# <p><em>Thank you for using nginx.</em></p>
# </body>
# </html>
exit

kubectl get all --show-labels
# NAME                                READY   STATUS    RESTARTS   AGE   LABELS
# pod/nginx-testing-clusterip-65jrn   1/1     Running   0          37m   app=nginx,environment=testing-clusterip
# pod/nginx-testing-clusterip-tc9vg   1/1     Running   0          37m   app=nginx,environment=testing-clusterip
# 
# NAME                        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE   LABELS
# service/kubernetes          ClusterIP   10.96.0.1       <none>        443/TCP    45h   component=apiserver,provider=kubernetes
# service/service-clusterip   ClusterIP   10.109.40.235   <none>        8080/TCP   12m   <none>
# 
# NAME                                      DESIRED   CURRENT   READY   AGE   LABELS
# replicaset.apps/nginx-testing-clusterip   2         2         2       37m   <none>

# To Access node we can use minikube
minikube ssh
# Last login: Fri Jan  1 23:36:18 2021 from 192.168.49.1

# So, we can perform request to cluster ip inside here, but no to service/service-clusterip by name
curl 10.109.40.235:8080
# <!DOCTYPE html>
# <html>
# <head>
# <title>Welcome to nginx!</title>
# <style>
#     body {
#         width: 35em;
#         margin: 0 auto;
#         font-family: Tahoma, Verdana, Arial, sans-serif;
#     }
# </style>
# </head>
# <body>
# <h1>Welcome to nginx!</h1>
# <p>If you see this page, the nginx web server is successfully installed and
# working. Further configuration is required.</p>
# 
# <p>For online documentation and support please refer to
# <a href="http://nginx.org/">nginx.org</a>.<br/>
# Commercial support is available at
# <a href="http://nginx.com/">nginx.com</a>.</p>
# 
# <p><em>Thank you for using nginx.</em></p>
# </body>
# </html>

curl service-clusterip:8080
# curl: (6) Could not resolve host: service-clusterip

logout
# ssh: Process exited with status 127

kubectl describe service service-clusterip 
# Name:              service-clusterip
# Namespace:         default
# Labels:            <none>
# Annotations:       <none>
# Selector:          app=nginx,environment=testing-clusterip
# Type:              ClusterIP
# IP Families:       <none>
# IP:                10.110.200.13
# IPs:               10.110.200.13
# Port:              <unset>  8080/TCP
# TargetPort:        80/TCP
# Endpoints:         172.17.0.5:80,172.17.0.6:80
# Session Affinity:  None
# Events:            <none>

kubectl describe svc service-clusterip 
# Name:              service-clusterip
# Namespace:         default
# Labels:            <none>
# Annotations:       <none>
# Selector:          app=nginx,environment=testing-clusterip
# Type:              ClusterIP
# IP Families:       <none>
# IP:                10.110.200.13
# IPs:               10.110.200.13
# Port:              <unset>  8080/TCP
# TargetPort:        80/TCP
# Endpoints:         172.17.0.5:80,172.17.0.6:80
# Session Affinity:  None
# Events:            <none>

# We can see 2 endpoint because they are the IPs that selecter labels matches on pods
# If we change replicas to 4, we should see 4 endpoints too
kubectl apply -f replicaset-clusterip.yml 
# replicaset.apps/nginx-testing-clusterip configured

kubectl describe svc service-clusterip 
# Name:              service-clusterip
# Namespace:         default
# Labels:            <none>
# Annotations:       <none>
# Selector:          app=nginx,environment=testing-clusterip
# Type:              ClusterIP
# IP Families:       <none>
# IP:                10.110.200.13
# IPs:               10.110.200.13
# Port:              <unset>  8080/TCP
# TargetPort:        80/TCP
# Endpoints:         172.17.0.5:80,172.17.0.6:80,172.17.0.7:80 + 1 more...
# Session Affinity:  None
# Events:            <none>

# The Session Affinity enable us to mantain request from same incoming clients IP to same Pod IP, usefull for sessions
# We will change the ClusterIP exposed port to 80 to pair with pod nginx service port
kubectl apply -f service-clusterip.yml 
# service/service-clusterip configured

kubectl describe svc service-clusterip 
# Name:              service-clusterip
# Namespace:         default
# Labels:            <none>
# Annotations:       <none>
# Selector:          app=nginx,environment=testing-clusterip
# Type:              ClusterIP
# IP Families:       <none>
# IP:                10.110.200.13
# IPs:               10.110.200.13
# Port:              <unset>  80/TCP
# TargetPort:        80/TCP
# Endpoints:         172.17.0.5:80,172.17.0.6:80,172.17.0.7:80 + 1 more...
# Session Affinity:  None
# Events:            <none>

minikube ssh
# Last login: Sat Jan  2 16:04:43 2021 from 192.168.49.1

# By default http request are mapped to port 80, so because previous change,
# we dont need to specify service port when you call to service cluster,
# that could has many pod replicas that our microservices.
curl 10.110.200.13
# <!DOCTYPE html>
# <html>
# <head>
# <title>Welcome to nginx!</title>
# <style>
#     body {
#         width: 35em;
#         margin: 0 auto;
#         font-family: Tahoma, Verdana, Arial, sans-serif;
#     }
# </style>
# </head>
# <body>
# <h1>Welcome to nginx!</h1>
# <p>If you see this page, the nginx web server is successfully installed and
# working. Further configuration is required.</p>
# 
# <p>For online documentation and support please refer to
# <a href="http://nginx.org/">nginx.org</a>.<br/>
# Commercial support is available at
# <a href="http://nginx.com/">nginx.com</a>.</p>
# 
# <p><em>Thank you for using nginx.</em></p>
# </body>
# </html>
exit
logout

kubectl get all
# NAME                                READY   STATUS    RESTARTS   AGE
# pod/nginx-testing-clusterip-65jrn   1/1     Running   0          57m
# pod/nginx-testing-clusterip-67d5n   1/1     Running   0          9m4s
# pod/nginx-testing-clusterip-6s47h   1/1     Running   0          9m4s
# pod/nginx-testing-clusterip-tc9vg   1/1     Running   0          57m
# 
# NAME                        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
# service/kubernetes          ClusterIP   10.96.0.1       <none>        443/TCP   45h
# service/service-clusterip   ClusterIP   10.110.200.13   <none>        80/TCP    12m
# 
# NAME                                      DESIRED   CURRENT   READY   AGE
# replicaset.apps/nginx-testing-clusterip   4         4         4       57m

kubectl exec -it nginx-testing-clusterip-65jrn -- bash
curl service-clusterip
# <!DOCTYPE html>
# <html>
# <head>
# <title>Welcome to nginx!</title>
# <style>
#     body {
#         width: 35em;
#         margin: 0 auto;
#         font-family: Tahoma, Verdana, Arial, sans-serif;
#     }
# </style>
# </head>
# <body>
# <h1>Welcome to nginx!</h1>
# <p>If you see this page, the nginx web server is successfully installed and
# working. Further configuration is required.</p>
# 
# <p>For online documentation and support please refer to
# <a href="http://nginx.org/">nginx.org</a>.<br/>
# Commercial support is available at
# <a href="http://nginx.com/">nginx.com</a>.</p>
# 
# <p><em>Thank you for using nginx.</em></p>
# </body>
# </html>

curl 10.110.200.13
# <!DOCTYPE html>
# <html>
# <head>
# <title>Welcome to nginx!</title>
# <style>
#     body {
#         width: 35em;
#         margin: 0 auto;
#         font-family: Tahoma, Verdana, Arial, sans-serif;
#     }
# </style>
# </head>
# <body>
# <h1>Welcome to nginx!</h1>
# <p>If you see this page, the nginx web server is successfully installed and
# working. Further configuration is required.</p>
#
# <p>For online documentation and support please refer to
# <a href="http://nginx.org/">nginx.org</a>.<br/>
# Commercial support is available at
# <a href="http://nginx.com/">nginx.com</a>.</p>
#
# <p><em>Thank you for using nginx.</em></p>
# </body>
# </html>
exit

kubectl delete -f .
# replicaset.apps "nginx-testing-clusterip" deleted
# service "service-clusterip" deleted

kubectl get all --show-labels
# NAME                                READY   STATUS        RESTARTS   AGE   LABELS
# pod/nginx-testing-clusterip-65jrn   0/1     Terminating   0          60m   app=nginx,environment=testing-clusterip
# 
# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE   LABELS
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   45h   component=apiserver,provider=kubernetes

