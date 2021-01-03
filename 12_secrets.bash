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

# The next step is create pod that can source from this credentials secret kind resource.
# The Pod will mount the secret resource on /etc/secrets as volume on read only mode.

kubectl apply -f pod-secrets.yml
# pod/nginx-secrets-mount created

kubectl get pods
# NAME                  READY   STATUS    RESTARTS   AGE
# nginx-cm              1/1     Running   0          62m
# nginx-secrets-mount   1/1     Running   0          10s

kubectl exec nginx-secrets-mount -- ls /etc/secrets
# password
# username

# On this way the apps can access the credentials

kubectl exec nginx-secrets-mount -- cat /etc/secrets/username
# admin

kubectl exec nginx-secrets-mount -- cat /etc/secrets/password
# 12356abcd 

# We can select and import different secrets, for example the password
kubectl apply -f pod-secret-mount-item.yml

kubectl get pods
# NAME                       READY   STATUS    RESTARTS   AGE
# nginx-cm                   1/1     Running   0          96m
# nginx-secrets-mount        1/1     Running   0          34m
# nginx-secrets-mount-item   1/1     Running   0          5m19s

kubectl exec nginx-secrets-mount-item -- cat /etc/secrets/password
# 12356abcd

# if we try to modify the content of pod-secret at now, it will fail,
kubectl apply -f pod-secret-mount-item.yml
# The Pod "nginx-secrets-mount-item" is invalid: spec: Forbidden: pod updates may not change fields other than `spec.containers[*].image`, `spec.initContainers[*].image`, `spec.activeDeadlineSeconds` or `spec.tolerations` (only additions to existing tolerations)
#   core.PodSpec{
#   	Volumes: []core.Volume{
#   		{
#   			Name: "secrets",
#   			VolumeSource: core.VolumeSource{
#   				... // 3 identical fields
#   				AWSElasticBlockStore: nil,
#   				GitRepo:              nil,
#   				Secret: &core.SecretVolumeSource{
#   					SecretName: "credentials-manifest",
#   					Items: []core.KeyToPath{
#   						{
# - 							Key:  "username",
# + 							Key:  "password",
# - 							Path: "username",
# + 							Path: "password",
#   							Mode: &500,
#   						},
#   					},
#   					DefaultMode: &420,
#   					Optional:    nil,
#   				},
#   				NFS:   nil,
#   				ISCSI: nil,
#   				... // 21 identical fields
#   			},
#   		},
#   		{Name: "default-token-cdk2f", VolumeSource: {Secret: &{SecretName: "default-token-cdk2f", DefaultMode: &420}}},
#   	},
#   	InitContainers: nil,
#   	Containers:     {{Name: "nginx", Image: "nginx:1.7.9", VolumeMounts: {{Name: "secrets", ReadOnly: true, MountPath: "/etc/secrets"}, {Name: "default-token-cdk2f", ReadOnly: true, MountPath: "/var/run/secrets/kubernetes.io/serviceaccount"}}, TerminationMessagePath: "/dev/termination-log", ...}},
#   	... // 27 identical fields
#   }

# because it is an inmutable resource we can't modify with a running pod
# So, we need to delete and create again
kubectl get pods
# NAME                       READY   STATUS    RESTARTS   AGE
# nginx-cm                   1/1     Running   0          96m
# nginx-secrets-mount        1/1     Running   0          34m
# nginx-secrets-mount-item   1/1     Running   0          5m19s

kubectl delete -f pod-secret-mount-item.yml
# pod "nginx-secrets-mount-item" deleted

kubectl apply -f pod-secret-mount-item.yml
# pod/nginx-secrets-mount-item created

# Notice that we no longer have the password variable
kubectl exec nginx-secrets-mount-item -- ls /etc/secrets
# username

kubectl exec nginx-secrets-mount-item -- cat /etc/secrets/username
# admin

# Now we will edit this secrets and that applies on real time
export EDITOR=nvim
kubectl get secrets
# NAME                   TYPE                                  DATA   AGE
# credentials            Opaque                                2      61m
# credentials-manifest   Opaque                                2      57m
# default-token-cdk2f    kubernetes.io/service-account-token   3      2d9h

# It will open the editor
# on inside we update the username value with new
echo superAdmin | base64
# c3VwZXJBZG1pbgo=

kubectl edit secrets credentials-manifest
# secret/credentials-manifest edited

# Change don't apply for ConfigMaps, because they were read on build time,
# so we need delete and create the pod again
# When you outcome from editor the changes will be applied automatically between om 30"-60"
kubectl exec nginx-secrets-mount-item -- cat /etc/secrets/username
# superAdmin

# Now, we try to do it from environmen variables
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
# username:  11 bytes

# Now we will source this items like container env var

kubectl apply -f pod-secret-mount-item-envvar.yml
# pod/nginx-secrets-mount-item-envvar created

kubectl get pods
# NAME                              READY   STATUS    RESTARTS   AGE
# nginx-cm                          1/1     Running   0          133m
# nginx-secrets-mount               1/1     Running   0          71m
# nginx-secrets-mount-item          1/1     Running   0          32m
# nginx-secrets-mount-item-envvar   1/1     Running   0          53s

kubectl exec nginx-secrets-mount-item-envvar -- env | grep SECRET_
# SECRET_USERNAME=superAdmin
# SECRET_PASSWORD=12345abcdef

# At this point we solved use cases for api keys storage, usernames and passwords,
# but at now will try to ssh for example if your pod should connect to repository.

ssh-keygen -f id_rsa
# Generating public/private rsa key pair.
# ...

# We will store this keys on secrets
# A good strategy is use it from files/directory
kubectl create secret generic ssh-key-secret --from-file=./id_rsa --from-file=./id_rsa.pub
# secret/ssh-key-secret created

kubectl describe secret ssh-key-secret
# Name:         ssh-key-secret
# Namespace:    default
# Labels:       <none>
# Annotations:  <none>
#
# Type:  Opaque
#
# Data
# ====
# id_rsa:      1675 bytes
# id_rsa.pub:  393 bytes

# Get Manifest
kubectl get secret ssh-key-secret -o yaml
# apiVersion: v1
# data:
#   id_rsa: LS0tLS ... ==
#   id_rsa.pub: c3NoL ... WEK
# kind: Secret
# metadata:
#   creationTimestamp: "2021-01-03T17:21:01Z"
#   managedFields:
#   - apiVersion: v1
#     fieldsType: FieldsV1
#     fieldsV1:
#       f:data:
#         .: {}
#         f:id_rsa: {}
#         f:id_rsa.pub: {}
#       f:type: {}
#     manager: kubectl-create
#     operation: Update
#     time: "2021-01-03T17:21:01Z"
#   name: ssh-key-secret
#   namespace: default
#   resourceVersion: "51455"
#   uid: b7695a22-3520-42db-9690-9402da64655e
# type: Opaque

# Remember that public and private keys are based on 64, also we don't need to set the public ip, with private key is enough.
# to generate a public key.
# We will create a pod with Env Vars mounted from credential-manifest secret, and ssh key from ssh-key-secret secret.
kubectl get secret
# NAME                   TYPE                                  DATA   AGE
# credentials            Opaque                                2      14h
# credentials-manifest   Opaque                                2      14h
# default-token-cdk2f    kubernetes.io/service-account-token   3      2d23h
# ssh-key-secret         Opaque                                2      12m

kubectl apply -f pod-secret-mount-item-envvar-w-ssh.yml
# pod/nginx-secrets-mount-item-envvar-w-ssh created

kubectl get pod
# NAME                                    READY   STATUS    RESTARTS   AGE
# nginx-cm                                1/1     Running   1          15h
# nginx-secrets-mount                     1/1     Running   1          14h
# nginx-secrets-mount-item                1/1     Running   1          13h
# nginx-secrets-mount-item-envvar         1/1     Running   1          13h
# nginx-secrets-mount-item-envvar-w-ssh   1/1     Running   0          14s

kubectl exec nginx-secrets-mount-item-envvar-w-ssh -- ls /root/.ssh
# id_rsa
# id_rsa.pub

kubectl exec nginx-secrets-mount-item-envvar-w-ssh -- cat /root/.ssh/id_rsa.pub
# ssh-rsa AAAAB3 ... angel@freya

kubectl exec nginx-secrets-mount-item-envvar-w-ssh -- env | grep SECRET_
SECRET_USERNAME=superAdmin
SECRET_PASSWORD=12345abcdef

