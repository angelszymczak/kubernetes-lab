#!/bin/bash

kubectl apply -f replicaset-nodeport.yml 
# replicaset.apps/nginx-testing-nodeport created

kubectl apply -f service1-nodeport.yml 
# service/service-nodeport created

kubectl get all
# NAME                               READY   STATUS    RESTARTS   AGE
# pod/nginx-testing-nodeport-cxgtx   1/1     Running   0          13m
# pod/nginx-testing-nodeport-q9bdk   1/1     Running   0          13m
# 
# NAME                        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
# service/kubernetes          ClusterIP   10.96.0.1       <none>        443/TCP        2d
# service/service-nodeport   NodePort    10.106.234.26   <none>        80:30212/TCP   5s
# 
# NAME                                     DESIRED   CURRENT   READY   AGE
# replicaset.apps/nginx-testing-nodeport   2         2         2       13m

# To give external access mapping from PORT 80 of service-nodeport to PORT 30212 of pod
# To give external access mapping from PORT 30212 of service-nodeport to PORT 80 of pod/nginx-testing-nodeport-*
minikube ssh
# Last login: Sat Jan  2 16:21:03 2021 from 192.168.49.1

curl 10.106.234.26
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
# logout

minikube ip
# 192.168.49.2

curl 192.168.49.2:30212
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

# If you delete the service and apply it again, the node port from will expose the PORT 80 of pod/nginx will change
kubectl delete -f service1-nodeport.yml 
# service "service-nodeport" deleted

kubectl apply -f service1-nodeport.yml 
# service/service-nodeport created

kubectl get all
# NAME                               READY   STATUS    RESTARTS   AGE
# pod/nginx-testing-nodeport-cxgtx   1/1     Running   0          23m
# pod/nginx-testing-nodeport-q9bdk   1/1     Running   0          23m
# 
# NAME                       TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
# service/kubernetes         ClusterIP   10.96.0.1      <none>        443/TCP        2d
# service/service-nodeport   NodePort    10.102.79.29   <none>        80:31201/TCP   6s
# 
# NAME                                     DESIRED   CURRENT   READY   AGE
# replicaset.apps/nginx-testing-nodeport   2         2         2       23m

# Notice that PORT now is 31201 instead of 30212 
curl 192.168.49.2:31212
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

# Because it is a ephemeral default port we can use fixed ports
kubectl apply -f service1-fixed-nodeport.yml
# service/service-nodeport configured

kubectl get all
# NAME                               READY   STATUS    RESTARTS   AGE
# pod/nginx-testing-nodeport-cxgtx   1/1     Running   0          27m
# pod/nginx-testing-nodeport-q9bdk   1/1     Running   0          27m
# 
# NAME                       TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
# service/kubernetes         ClusterIP   10.96.0.1      <none>        443/TCP        2d
# service/service-nodeport   NodePort    10.102.79.29   <none>        80:30009/TCP   4m13s
# 
# NAME                                     DESIRED   CURRENT   READY   AGE
# replicaset.apps/nginx-testing-nodeport   2         2         2       27m

curl 192.168.49.2:30009
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

kubectl delete -f service1-fixed-nodeport.yml
# service "service-nodeport" deleted

kubectl apply -f service1-fixed-nodeport.yml
# service/service-nodeport created

kubectl get all
# NAME                               READY   STATUS    RESTARTS   AGE
# pod/nginx-testing-nodeport-cxgtx   1/1     Running   0          28m
# pod/nginx-testing-nodeport-q9bdk   1/1     Running   0          28m
#
# NAME                       TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)        AGE
# service/kubernetes         ClusterIP   10.96.0.1    <none>        443/TCP        2d
# service/service-nodeport   NodePort    10.97.70.4   <none>        80:30009/TCP   3s
# 
# NAME                                     DESIRED   CURRENT   READY   AGE
# replicaset.apps/nginx-testing-nodeport   2         2         2       28m

curl 192.168.49.2:30009
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

kubectl delete -f replicaset-nodeport.yml -f service1-fixed-nodeport.yml 
# replicaset.apps "nginx-testing-nodeport" deleted
# service "service-nodeport" deleted

kubectl get all
# NAME                               READY   STATUS        RESTARTS   AGE
# pod/nginx-testing-nodeport-cxgtx   0/1     Terminating   0          30m
# pod/nginx-testing-nodeport-q9bdk   0/1     Terminating   0          30m
# 
# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   2d

