#!/bin/bashll

kubectl get all
# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   2d6h

kubectl get cm
# NAME               DATA   AGE
# kube-root-ca.crt   1      14m

kubectl get configmap
# NAME               DATA   AGE
# kube-root-ca.crt   1      15m
angel@freya:~/Labs/kubernetes-lab$ kubectl get configmaps
# NAME               DATA   AGE
# kube-root-ca.crt   1      15m
angel@freya:~/Labs/kubernetes-lab$ kubectl create configmap test-cm --from-literal key1=value1
# configmap/test-cm created
angel@freya:~/Labs/kubernetes-lab$ # It key will be stored on an ConfigMap object that our pon can access to read this contents
angel@freya:~/Labs/kubernetes-lab$ # For this reason the content shouldn't be on the image
angel@freya:~/Labs/kubernetes-lab$ kubectl get cm -oyaml
# apiVersion: v1
# items:
# - apiVersion: v1
#   data:
#     ca.crt: |
#       -----BEGIN CERTIFICATE-----
#       MIIDBjCCAe6gAwIBAgIBATANBgkqhkiG9w0BAQsFADAVMRMwEQYDVQQDEwptaW5p
#       a3ViZUNBMB4XDTIwMTIzMDE1NDc0OFoXDTMwMTIyOTE1NDc0OFowFTETMBEGA1UE
#       AxMKbWluaWt1YmVDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANm0
#       9B8GWzfVbwZJG6cuv7cmHPhKdfi7R/GziAINtkhr4iJvG0anmWPvN8QUu2IDTq/l
#       JhegGvsY18rWDvQD81f/8QmVGhh2kc81956uivZe61fReuwqQRInxQOjfh1Xgltk
#       KdmFGQb5R+kIfco9kkDj8xlTSNjNlQWFwiqF643zMGlRqxSrYDEbrHB6IDt984mV
#       kN+hZRuc1EZPd+UQtPZ/70jP2xfHcpYRm8ynCFDrnbuzvh4oagfSugMgMbKDqWoP
#       pEr0+Kkxc3xKCzGWObBYy3Cs5Nij1QuN6nRNLjFOj9pvQxIvi2M2lx+tP7ANEvYm
#       0sGs5/k3ttxuNoX43vsCAwEAAaNhMF8wDgYDVR0PAQH/BAQDAgKkMB0GA1UdJQQW
      MBQGCCsGAQUFBwMCBggrBgEFBQcDATAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQW
#       BBQ96QfLFGtj0xSBwPBLysADPN8qpTANBgkqhkiG9w0BAQsFAAOCAQEALcwXXLtD
#       ZyTsvXGi5YmlRgEFhxoe+GxtTeoZLg/aP3tKo8WKBKkucdVFg1tjrnt+WBcYkDrd
#       lfoQTP0HQ8i/WjyYEPBs7EXn4dANc+i/Tcdsx1h/mkvunURBVetlxUyJnsaPr5hq
# #       s605TNSwR5fJ3cXMB3KDpsUJ4KMf6kI9uyWpRusfLLuigoXOJOZ4Qu6GilCN5swI
#       N2FW3WLWQuNVuYUIVg0Nnp4VsqFBpTKQLYVt5UORkIOTLe0JzBcUBIMrSYRnRRrt
      vtznHmWq3CQeT5oL0umG+u11fE95vTJihcnxJHaXiZ/eDbfuWH5ep45hgoZPAIkN
#       NHvpUZakorn+ww==
#       -----END CERTIFICATE-----
#   kind: ConfigMap
#   metadata:
#     creationTimestamp: "2021-01-03T01:04:57Z"
#     managedFields:
#     - apiVersion: v1
#       fieldsType: FieldsV1
#       fieldsV1:
#         f:data:
#           .: {}
#           f:ca.crt: {}
#       manager: kube-controller-manager
#       operation: Update
#       time: "2021-01-03T01:04:57Z"
#       name: kube-root-ca.crt
#     namespace: default
#     resourceVersion: "40801"
#     uid: 1561c822-5aa1-45d1-ac60-e8d7723f5e76
# - apiVersion: v1
#   data:
#     key1: value1
#   kind: ConfigMap
#   metadata:
#     creationTimestamp: "2021-01-03T01:23:15Z"
#     managedFields:
#     - apiVersion: v1
#       fieldsType: FieldsV1
#       fieldsV1:
#         f:data:
#           .: {}
#           f:key1: {}
#       manager: kubectl-create
#       operation: Update
#       time: "2021-01-03T01:23:15Z"
#     name: test-cm
#     namespace: default
#     resourceVersion: "41569"
#     uid: c8f0dcc5-d836-417d-8418-0d57e7f17e3f
# kind: List
# metadata:
#   resourceVersion: ""
#   selfLink: ""

kubectl get cm -oyaml | grep key
#    key1: value1
#          f:key1: {}

kubectl describe cm test-cm
# Name:         test-cm
# Namespace:    default
# Labels:       <none>
# Annotations:  <none>
# 
# Data
# ====
# key1:
# ----
# value1
# Events:  <none>

# We can create this object from a file using the emulator mode
kubectl create cm test-cm --from-literal key1=value1 --from-literal key2=value2 --dry-run=client -oyaml
# apiVersion: v1
# data:
#   key1: value1
#   key2: value2
# kind: ConfigMap
# metadata:
#   creationTimestamp: null
#   name: test-cm

kubectl delete cm test-cm
# configmap "test-cm" deleted

kubectl create cm test-cm --from-literal key1=value1 --from-literal key2=value2
# configmap/test-cm created

kubectl describe cm test-cm
# Name:         test-cm
# Namespace:    default
# Labels:       <none>
# Annotations:  <none>
# 
# Data
# ====
# key1:
# ----
# value1
# key2:
# ----
# value2
# Events:  <none>

kubectl apply -f cm-pod-literal.yml 
# pod/nginx-cm created

kubectl get all
# NAME           READY   STATUS    RESTARTS   AGE
# pod/nginx-cm   1/1     Running   0          13s
# 
# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   2d7h

kubectl get cm 
# NAME               DATA   AGE
# kube-root-ca.crt   1      50m
# test-cm            2      4m26s
exit

kubectl exec nginx-cm -- env | grep ENVIRONMENT_VAR_
# ENVIRONMENT_VAR_1=value1
# ENVIRONMENT_VAR_2=value2

# Inyecting config from directories and files

cat cm-pod-file.yml | grep mountPath
#        mountPath: /etc/nginx/conf.d/

kubectl exec nginx-cm-file -- mount | grep nginx
# /dev/sda1 on /etc/nginx/conf.d type ext4 (ro,relatime,errors=remount-ro)

kubectl exec nginx-cm-file -- ls /etc/nginx/conf.d
# default.conf
# test.conf

kubectl exec nginx-cm-file -- cat /etc/nginx/conf.d/default.conf
# server {
#     listen       80;
#     server_name  myweb.com;
# 
#     location / {
#         root   /usr/share/nginx/html;
#         index  index.html index.htm;
#     }
# }

kubectl exec nginx-cm-file -- cat /etc/nginx/conf.d/test.conf
# server {
#     listen       8080;
#     server_name  test.myweb.com;
# 
#     location / {
#         root   /var/www/html/;
#         index  index.html index.htm;
#     }
# }

# Notice that the ConfigMap volume is a filesystem on read only
kubectl exec nginx-cm-file -- touch /etc/nginx/conf.d/testfile
# touch: cannot touch '/etc/nginx/conf.d/testfile': Read-only file system
# command terminated with exit code 1

kubectl exec nginx-cm-file -- curl localhost:8080
#   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
#                                  Dload  Upload   Total   Spent    Left  Speed
# 100   <html> 0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
# <head><title>404 Not Found</title></head>
# <body>
# <center><h1>404 Not Found</h1></center>
# <hr><center>nginx/1.19.6</center>
# </body>
# </html>
# 153  100   153    0     0  51000      0 --:--:-- --:--:-- --:--:-- 51000

kubectl exec nginx-cm-file -- bash
cat /var/www/html/index.html 
# <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
# <html xmlns="http://www.w3.org/1999/xhtml">
#   <!--
#     Modified from the Debian original for Ubuntu
#     Last updated: 2016-11-16
#     See: https://launchpad.net/bugs/1288690
#   -->
#   <head>
#  ... 
#  </body>
# </html>

kubectl exec -it nginx-cm-file -- bash
echo hola > /var/www/html/index.html
exit

kubectl exec nginx-cm-file -- cat /var/www/html/index.html
# hola

kubectl exec nginx-cm-file -- curl localhost:8080
# hola

kubectl exec nginx-cm-file -- curl localhost:8080 -H 'host: test.myweb.com'
# hola

kubectl exec nginx-cm-file -- curl localhost:8080 -H 'host: myweb.com'
# hola

# On this way we can create many nginx pod with your configuration resource from shared ConfigMaps
# Using a public nginx image but inyecting our configurations
# We will use different configurations for Testing, Staging, Production or other environments.
kubectl delete -f .
# pod "nginx-cm-file" deleted
# pod "nginx-cm" deleted

# ConfigMaps weren't deleted so we need specify to cm component
kubectl delete cm --all
# configmap "kube-root-ca.crt" deleted
# configmap "nginx-config-dir" deleted
# configmap "test-cm" deleted

