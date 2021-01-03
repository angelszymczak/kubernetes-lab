#!/bin/bash
# The Deployment resource manages the Pods through ReplicaSet resources that itself create

# Here we will deploy 2 Nginx Pods
kubectl apply -f nginx-deployment.yml

kubectl get all
# NAME                                    READY   STATUS              RESTARTS   AGE
# pod/nginx-deployment-5d59d67564-29bsj   0/1     ContainerCreating   0          1s
# pod/nginx-deployment-5d59d67564-464x5   0/1     ContainerCreating   0          1s
# pod/nginx-deployment-5d59d67564-8chpf   0/1     ContainerCreating   0          1s
# pod/nginx-deployment-5d59d67564-cpq5m   0/1     ContainerCreating   0          1s
# pod/nginx-deployment-5d59d67564-hsngm   0/1     ContainerCreating   0          1s
# pod/nginx-deployment-5d59d67564-mpgkk   0/1     ContainerCreating   0          1s
# pod/nginx-deployment-5d59d67564-nkxm7   0/1     Pending             0          1s
# pod/nginx-deployment-5d59d67564-nvcq5   0/1     ContainerCreating   0          1s
# pod/nginx-deployment-5d59d67564-nzb6p   0/1     Pending             0          1s
# pod/nginx-deployment-5d59d67564-x8nxj   0/1     Pending             0          1s
# 
# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d1h
# 
# NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/nginx-deployment   0/10    10           0           1s
# 
# NAME                                          DESIRED   CURRENT   READY   AGE
# replicaset.apps/nginx-deployment-5d59d67564   10

# If we need deploy a new version, K8s will created a new deployment with desired replicas and
# when them be ready will set old deployment replicaset to zero, so we could perform rollbacks if we need 
# If we update replicas numbers and apply it again, we will can it, for example to 5.

kubectl apply -f nginx-deployment.yml
# deployment.apps/nginx-deployment configured

kubectl get all
# NAME                                    READY   STATUS        RESTARTS   AGE
# pod/nginx-deployment-5d59d67564-29bsj   0/1     Terminating   0          4m
# pod/nginx-deployment-5d59d67564-464x5   0/1     Terminating   0          4m
# pod/nginx-deployment-5d59d67564-8chpf   1/1     Running       0          4m
# pod/nginx-deployment-5d59d67564-cpq5m   1/1     Running       0          4m
# pod/nginx-deployment-5d59d67564-hsngm   1/1     Running       0          4m
# pod/nginx-deployment-5d59d67564-mpgkk   0/1     Terminating   0          4m
# pod/nginx-deployment-5d59d67564-nkxm7   0/1     Terminating   0          4m
# pod/nginx-deployment-5d59d67564-nvcq5   0/1     Terminating   0          4m
# pod/nginx-deployment-5d59d67564-nzb6p   1/1     Running       0          4m
# pod/nginx-deployment-5d59d67564-x8nxj   1/1     Running       0          4m
# 
# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d1h
# 
# NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/nginx-deployment   5/5     5            5           4m
# 
# NAME                                          DESIRED   CURRENT   READY   AGE
# replicaset.apps/nginx-deployment-5d59d67564   5

# And then to 10 again
kubectl apply -f nginx-deployment.yml
# deployment.apps/nginx-deployment configured

kubectl get all
# NAME                                    READY   STATUS              RESTARTS   AGE
# pod/nginx-deployment-5d59d67564-8chpf   1/1     Running             0          4m53s
# pod/nginx-deployment-5d59d67564-cpq5m   1/1     Running             0          4m53s
# pod/nginx-deployment-5d59d67564-hc828   0/1     ContainerCreating   0          3s
# pod/nginx-deployment-5d59d67564-hsngm   1/1     Running             0          4m53s
# pod/nginx-deployment-5d59d67564-nzb6p   1/1     Running             0          4m53s
# pod/nginx-deployment-5d59d67564-r7ztb   0/1     ContainerCreating   0          3s
# pod/nginx-deployment-5d59d67564-rg6nv   1/1     Running             0          3s
# pod/nginx-deployment-5d59d67564-w7gln   1/1     Running             0          3s
# pod/nginx-deployment-5d59d67564-x7nbm   0/1     ContainerCreating   0          3s
# pod/nginx-deployment-5d59d67564-x8nxj   1/1     Running             0          4m53s
# 
# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d1h
# 
# NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/nginx-deployment   7/10    10           7           4m53s
# 
# NAME                                          DESIRED   CURRENT   READY   AGE
# replicaset.apps/nginx-deployment-5d59d67564   10        10        7       4m53s

# In this change only the replicas was updated, but a new version will be created if we change the image version
kubectl apply -f nginx-deployment.yml
# deployment.apps/nginx-deployment configured

kubectl get all
# NAME                                    READY   STATUS              RESTARTS   AGE
# pod/nginx-deployment-5d59d67564-8chpf   1/1     Running             0          8m33s
# pod/nginx-deployment-5d59d67564-cpq5m   1/1     Running             0          8m33s
# pod/nginx-deployment-5d59d67564-hc828   1/1     Terminating         0          3m43s
# pod/nginx-deployment-5d59d67564-hsngm   1/1     Running             0          8m33s
# pod/nginx-deployment-5d59d67564-nzb6p   1/1     Running             0          8m33s
# pod/nginx-deployment-5d59d67564-r7ztb   0/1     Terminating         0          3m43s
# pod/nginx-deployment-5d59d67564-rg6nv   1/1     Terminating         0          3m43s
# pod/nginx-deployment-5d59d67564-w7gln   1/1     Running             0          3m43s
# pod/nginx-deployment-5d59d67564-x7nbm   1/1     Terminating         0          3m43s
# pod/nginx-deployment-5d59d67564-x8nxj   1/1     Running             0          8m33s
# pod/nginx-deployment-75b69bd684-2j6kq   1/1     Running             0          2s
# pod/nginx-deployment-75b69bd684-bq8bm   0/1     Pending             0          0s
# pod/nginx-deployment-75b69bd684-c75qr   0/1     ContainerCreating   0          2s
# pod/nginx-deployment-75b69bd684-cd9h6   0/1     ContainerCreating   0          2s
# pod/nginx-deployment-75b69bd684-m2f8v   0/1     ContainerCreating   0          0s
# pod/nginx-deployment-75b69bd684-nlrt9   1/1     Running             0          2s
# pod/nginx-deployment-75b69bd684-xtgsd   0/1     ContainerCreating   0          2s
# 
# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d1h
# 
# NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/nginx-deployment   8/10    7            8           8m33s
# 
# NAME                                          DESIRED   CURRENT   READY   AGE
# replicaset.apps/nginx-deployment-5d59d67564   6         6         6       8m33s
# replicaset.apps/nginx-deployment-75b69bd684   7         7         2       2s

# And if we undo changes, and apply changes again
kubectl apply -f nginx-deployment.yml
# deployment.apps/nginx-deployment configured

kubectl get all
# NAME                                    READY   STATUS              RESTARTS   AGE
# pod/nginx-deployment-5d59d67564-7rn49   0/1     ContainerCreating   0          3s
# pod/nginx-deployment-5d59d67564-bt9dc   0/1     ContainerCreating   0          3s
# pod/nginx-deployment-5d59d67564-pk2bm   0/1     ContainerCreating   0          3s
# pod/nginx-deployment-5d59d67564-pkh97   0/1     ContainerCreating   0          3s
# pod/nginx-deployment-5d59d67564-xgg76   0/1     ContainerCreating   0          3s
# pod/nginx-deployment-75b69bd684-2j6kq   1/1     Running             0          114s
# pod/nginx-deployment-75b69bd684-97zt9   1/1     Terminating         0          110s
# pod/nginx-deployment-75b69bd684-bq8bm   1/1     Running             0          112s
# pod/nginx-deployment-75b69bd684-c75qr   1/1     Running             0          114s
# pod/nginx-deployment-75b69bd684-cd9h6   1/1     Running             0          114s
# pod/nginx-deployment-75b69bd684-hb66z   1/1     Terminating         0          108s
# pod/nginx-deployment-75b69bd684-m2f8v   1/1     Running             0          112s
# pod/nginx-deployment-75b69bd684-nlrt9   1/1     Running             0          114s
# pod/nginx-deployment-75b69bd684-xl7r2   1/1     Running             0          111s
# pod/nginx-deployment-75b69bd684-xtgsd   1/1     Running             0          114s
# 
# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   3d1h
# 
# NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/nginx-deployment   8/10    5            8           10m
# 
# NAME                                          DESIRED   CURRENT   READY   AGE
# replicaset.apps/nginx-deployment-5d59d67564   5         5         0       10m
# replicaset.apps/nginx-deployment-75b69bd684   8         8         8       114s

# And the previous version was re-deployed

