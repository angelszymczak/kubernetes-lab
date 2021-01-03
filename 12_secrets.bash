#!/bin/bash

# Is a good idea use secret to share users, credentials, api keys, and sensitive data,
# if the volume could be stolen, but the data is encrypted
echo -n admin > username
echo -n 12345abcdef > password

# We use -n option to write without jump lines
kubectl create secret generic credentials --from-file=./username --from-file=./password
# secret/credentials created

kubectl get secrets
# NAME                  TYPE                                  DATA   AGE
# credentials           Opaque                                2      7s
# default-token-cdk2f   kubernetes.io/service-account-token   3      2d8h

kubectl create secret generic credentials --from-file=./username --from-file=./password --dry-run=client -oyaml
# apiVersion: v1
# data:
#   password: MTIzNDVhYmNkZWY=
#   username: YWRtaW4=
# kind: Secret
# metadata:
#   creationTimestamp: null
#   name: credentials

# We can get the yaml code to create the manifest
# Notice that password and username aren't encrypted
# They are base 64 encoded to avoid unexpected chars, quotes, more compacted, etc.
echo MTIzNDVhYmNkZWY= | base64 -d
# 12345abcdef

kubectl apply -f secret-credentials.yml 
# secret/credentials-manifest created

kubectl get secrets
# NAME                   TYPE                                  DATA   AGE
# credentials            Opaque                                2      3m56s
# credentials-manifest   Opaque                                2      5s
# default-token-cdk2f    kubernetes.io/service-account-token   3      2d8h

cat secret-credentials.yml | grep name
#   name: credentials-manifest
#   username: YWRtaW4=

# Notice that we can't get content
kubectl describe secret credentials-manifest
# Name:         credentials-manifest
# Namespace:    default
# Labels:       <none>
# Annotations:  <none>
# 
# Type:  Opaque
# 
# Data
# ====
# password:  11 bytes
# username:  5 bytes

kubectl get secret credentials-manifest -oyaml
# apiVersion: v1
# data:
#   password: MTIzNTZhYmNkIAo=
#   username: YWRtaW4=
# kind: Secret
# metadata:
#   annotations:
#     kubectl.kubernetes.io/last-applied-configuration: |
#       {"apiVersion":"v1","data":{"password":"MTIzNTZhYmNkIAo=","username":"YWRtaW4="},"kind":"Secret","metadata":{"annotations":{},"name":"credentials-manifest","namespace":"default"},"type":"Opaque"}
#   creationTimestamp: "2021-01-03T02:44:18Z"
#   managedFields:
#   - apiVersion: v1
#     fieldsType: FieldsV1
#     fieldsV1:
#       f:data:
#         .: {}
#         f:password: {}
#         f:username: {}
#       f:metadata:
#         f:annotations:
#           .: {}
#           f:kubectl.kubernetes.io/last-applied-configuration: {}
#       f:type: {}
#     manager: kubectl-client-side-apply
#     operation: Update
#     time: "2021-01-03T02:44:18Z"
#   name: credentials-manifest
#   namespace: default
#   resourceVersion: "44966"
#   uid: 722177be-2c29-41b8-aed1-5ee3069c0bd6
# type: Opaque

kubectl get secret credentials-manifest -oyaml | grep password
#  password: MTIzNTZhYmNkIAo=
#      {"apiVersion":"v1","data":{"password":"MTIzNTZhYmNkIAo=","username":"YWRtaW4="},"kind":"Secret","metadata":{"annotations":{},"name":"credentials-manifest","namespace":"default"},"type":"Opaque"}
#        f:password: {}

echo MTIzNTZhYmNkIAo= | base64 -d
# 12356abcd 

kubectl get secrets
# NAME                   TYPE                                  DATA   AGE
# credentials            Opaque                                2      15m
# credentials-manifest   Opaque                                2      11m
# default-token-cdk2f    kubernetes.io/service-account-token   3      2d8h
# Now we will mount the credentials-manifest secret nginx pod like a volume on /etc/secrets path as read only

# Ok, we have created a credentials object with an username and password source by files that
# we can source with username and password files, and then will be encoded to base64
