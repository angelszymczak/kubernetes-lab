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
#
# And the previous version was re-deployed

# Pause and Resumen command

kubectl rollout pause deployment nginx-deployment
# deployment.apps/nginx-deployment paused
#
# All will be working but you won't can do rollouts 
# So, why we want to use it?
# Supose that you have all commands automated from a Jenkins/CI/CD, so,
# it will be sending continuously those commands
# supose you want to stop one momment to review any issue

# let's to do rollout pause and if any change was applied on any resource,
# it's will response with "ok", but won't apply it changes to rollout resume run
kubectl set image deployment nginx-deployment nginx=nginx:latest --record=true
# deployment.apps/nginx-deployment image updated
#
# Every 1,0s: kubectl get all                                           freya: Tue Jan  5 20:47:31 2021
# 
# NAME                                    READY   STATUS    RESTARTS   AGE
# pod/nginx-deployment-5d59d67564-jqlf9   1/1     Running   0          57m
# pod/nginx-deployment-5d59d67564-mp587   1/1     Running   0          57m
# 
# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   5d5h
# 
# NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/nginx-deployment   2/2     0            2           5h19m
# 
# NAME                                          DESIRED   CURRENT   READY   AGE
# replicaset.apps/nginx-deployment-5d59d67564   2         2         2       5h19m
# replicaset.apps/nginx-deployment-698676d7f8   0         0         0       5h6m
# replicaset.apps/nginx-deployment-75b69bd684   0         0         0       5h
# replicaset.apps/nginx-deployment-78bbb6dfc6   0         0         0       5h1m

# And deployments aren't swapping
# But we won't apply history revissions with paused rollout
kubectl rollout history deployment nginx-deployment
# deployment.apps/nginx-deployment 
# REVISION  CHANGE-CAUSE
# 4         kubectl set image deployment nginx-deployment nginx=nginx:1.7.5 --record=true
# 5         kubectl set image deployment nginx-deployment nginx=nginx:1.5 --record=true
# 8         kubectl set image deployment nginx-deployment nginx=nginx:1.15 --record=true
# 9         kubectl set image deployment nginx-deployment nginx=nginx:1.7.9 --record=true
# 10        kubectl set image deployment nginx-deployment nginx=nginx:latest --record=true

kubectl set image deployment nginx-deployment nginx=nginx:latest --record
# The current is REVISION 10
# And deployments aren't swapping

kubectl set image deployment nginx-deployment nginx=nginx:1.7.9 --record
# deployment.apps/nginx-deployment image updated

kubectl rollout history deployment nginx-deployment
# deployment.apps/nginx-deployment 
# REVISION  CHANGE-CAUSE
# 4         kubectl set image deployment nginx-deployment nginx=nginx:1.7.5 --record=true
# 5         kubectl set image deployment nginx-deployment nginx=nginx:1.5 --record=true
# 8         kubectl set image deployment nginx-deployment nginx=nginx:1.15 --record=true
# 10        kubectl set image deployment nginx-deployment nginx=nginx:latest --record=true
# 11        kubectl set image deployment nginx-deployment nginx=nginx:1.7.9 --record=true
# 
# The new revision was created, but it wont be applied to kubectl rollout resume
# 
# very 1,0s: kubectl get all                                           freya: Tue Jan  5 20:56:42 2021
# 
# NAME                                    READY   STATUS    RESTARTS   AGE
# pod/nginx-deployment-5d59d67564-jqlf9   1/1     Running   0          66m
# pod/nginx-deployment-5d59d67564-mp587   1/1     Running   0          66m
# 
# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   5d5h
# 
# NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/nginx-deployment   2/2     2            2           5h28m
# 
# NAME                                          DESIRED   CURRENT   READY   AGE
# replicaset.apps/nginx-deployment-5d59d67564   2         2         2       5h28m
# replicaset.apps/nginx-deployment-698676d7f8   0         0         0       5h16m
# replicaset.apps/nginx-deployment-75b69bd684   0         0         0       5h10m
# replicaset.apps/nginx-deployment-78bbb6dfc6   0         0         0       5h11m

# Also, we can't move between revission
kubectl rollout history deployment nginx-deployment
# deployment.apps/nginx-deployment 
# REVISION  CHANGE-CAUSE
# 4         kubectl set image deployment nginx-deployment nginx=nginx:1.7.5 --record=true
# 5         kubectl set image deployment nginx-deployment nginx=nginx:1.5 --record=true
# 8         kubectl set image deployment nginx-deployment nginx=nginx:1.15 --record=true
# 10        kubectl set image deployment nginx-deployment nginx=nginx:latest --record=true
# 11        kubectl set image deployment nginx-deployment nginx=nginx:1.7.9 --record=true

kubectl rollout undo deployment nginx-deployment --to-revision=8
# error: you cannot rollback a paused deployment; resume it first with 'kubectl rollout resume deployment/nginx-deployment' and try again

# So resume and It will be showing changes on monitoring
kubectl rollout resume deployment nginx-deployment
# deployment.apps/nginx-deployment resumed

kubectl rollout undo deployment nginx-deployment --to-revision=8
# deployment.apps/nginx-deployment rolled back

# Every 1,0s: kubectl get all                                           freya: Tue Jan  5 21:06:12 2021
# 
# NAME                                    READY   STATUS              RESTARTS   AGE
# pod/nginx-deployment-5d59d67564-jqlf9   1/1     Running             0          76m
# pod/nginx-deployment-5d59d67564-mp587   1/1     Running             0          76m
# pod/nginx-deployment-698676d7f8-g56kk   0/1     ContainerCreating   0          1s
# 
# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   5d5h
# 
# NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/nginx-deployment   2/2     1            2           5h38m
# 
# NAME                                          DESIRED   CURRENT   READY   AGE
# replicaset.apps/nginx-deployment-5d59d67564   2         2         2       5h38m
# replicaset.apps/nginx-deployment-698676d7f8   1         1         0       5h25m
# replicaset.apps/nginx-deployment-75b69bd684   0         0         0       5h19m
# 
# The revision is applying

# Status command
# This command allow you to watch which status is an deployment running on
kubectl rollout status deployment nginx-deployment
# deployment "nginx-deployment" successfully rolled out
#
# let to clean stored images 
minikube ssh
# Last login: Tue Jan  5 18:21:11 2021 from 192.168.49.1

docker images | grep nginx
# nginx                                     latest     ae2feff98a0c   3 weeks ago     133MB
# nginx                                     1.15       53f3fd8007f7   20 months ago   109MB
# nginx                                     1.7.9      84581e99d807   5 years ago     91.7MB
# nginx                                     1.7.5      bb8910d71cfe   6 years ago     100MB
# docker image rm nginx:latest nginx:1.15 nginx:1.7.9 nginx:1.7.5
exit

kubectl delete -f nginx-deployment.yml 
# deployment.apps "nginx-deployment" deleted
#
# Every 1,0s: kubectl get all                                           freya: Tue Jan  5 21:16:45 2021
# 
# NAME                                    READY   STATUS        RESTARTS   AGE
# pod/nginx-deployment-698676d7f8-8qd7l   0/1     Terminating   0          10m
# pod/nginx-deployment-698676d7f8-g56kk   0/1     Terminating   0          10m
# 
# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   5d5h

# Let's open on another terminel an run inmediatly after apply your deployment
# kubectl rollout status deployment nginx-deployment -w
kubectl apply -f nginx-deployment.yml 
# deployment.apps/nginx-deployment created
# 
# Every 1,0s: kubectl get all                                           freya: Tue Jan  5 21:21:26 2021
# 
# NAME                                    READY   STATUS              RESTARTS   AGE
# pod/nginx-deployment-5d59d67564-7tqqz   0/1     ContainerCreating   0          9s
# pod/nginx-deployment-5d59d67564-gsp5v   0/1     ContainerCreating   0          9s
# 
# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   5d5h
# 
# NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/nginx-deployment   0/2     2            0           9s
# 
# NAME                                          DESIRED   CURRENT   READY   AGE
# replicaset.apps/nginx-deployment-5d59d67564   2         2         0       9s

# On status watching
# Waiting for deployment nginx-deployment rollout to finish: 0 of 2 updated replicas are available...
# Waiting for deployment nginx-deployment rollout to finish: 1 of 2 updated replicas are available...
# deployment nginx-deployment successfully rolled out

# So if we change replicas to ten again we can also will see on monitors
# We will update to 10 replicas and then change the image version to watch both outputs
kubectl apply -f nginx-deployment.yml 
# deployment.apps/nginx-deployment configured

kubectl set image deployment nginx-deployment nginx=nginx:1.15 --record=true
# deployment.apps/nginx-deployment image updated
#
# Every 1,0s: kubectl get all                                           freya: Tue Jan  5 21:26:05 2021
# 
# NAME                                    READY   STATUS              RESTARTS   AGE
# pod/nginx-deployment-5d59d67564-7dkwm   1/1     Terminating         0          91s
# pod/nginx-deployment-5d59d67564-7tqqz   1/1     Terminating         0          4m49s
# pod/nginx-deployment-5d59d67564-8cgl2   0/1     Terminating         0          91s
# pod/nginx-deployment-5d59d67564-bmj7p   0/1     Terminating         0          91s
# pod/nginx-deployment-5d59d67564-gsp5v   1/1     Terminating         0          4m49s
# pod/nginx-deployment-5d59d67564-jvgcw   0/1     Terminating         0          91s
# pod/nginx-deployment-5d59d67564-rtz52   0/1     Terminating         0          91s
# pod/nginx-deployment-5d59d67564-xpfqr   0/1     Terminating         0          91s
# pod/nginx-deployment-5d59d67564-zqs26   0/1     Terminating         0          91s
# pod/nginx-deployment-698676d7f8-65rxc   1/1     Running             0          4s
# pod/nginx-deployment-698676d7f8-6xmpn   1/1     Running             0          13s
# pod/nginx-deployment-698676d7f8-8t9vp   1/1     Running             0          13s
# pod/nginx-deployment-698676d7f8-99dbp   1/1     Running             0          9s
# pod/nginx-deployment-698676d7f8-gcvt5   1/1     Running             0          7s
# pod/nginx-deployment-698676d7f8-jqsw4   0/1     ContainerCreating   0          13s
# pod/nginx-deployment-698676d7f8-m2h78   1/1     Running             0          7s
# pod/nginx-deployment-698676d7f8-m5p85   0/1     ContainerCreating   0          13s
# pod/nginx-deployment-698676d7f8-xqwd4   1/1     Running             0          13s
# pod/nginx-deployment-698676d7f8-zkgzs   1/1     Running             0          4s
# 
# NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
# service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   5d5h
# 
# NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/nginx-deployment   8/10    10           8           4m49s
# 
# NAME                                          DESIRED   CURRENT   READY   AGE
# replicaset.apps/nginx-deployment-5d59d67564   0         0         0       4m49s
# replicaset.apps/nginx-deployment-698676d7f8   10        10        8       13s

kubectl rollout status deployment nginx-deployment -w
# Waiting for deployment nginx-deployment rollout to finish: 5 out of 10 new replicas have been updated...
# Waiting for deployment nginx-deployment rollout to finish: 5 out of 10 new replicas have been updated...
# Waiting for deployment nginx-deployment rollout to finish: 6 out of 10 new replicas have been updated...
# Waiting for deployment nginx-deployment rollout to finish: 6 out of 10 new replicas have been updated...
# Waiting for deployment nginx-deployment rollout to finish: 6 out of 10 new replicas have been updated...
# Waiting for deployment nginx-deployment rollout to finish: 6 out of 10 new replicas have been updated...
# Waiting for deployment nginx-deployment rollout to finish: 6 out of 10 new replicas have been updated...
# Waiting for deployment nginx-deployment rollout to finish: 6 out of 10 new replicas have been updated...
# Waiting for deployment nginx-deployment rollout to finish: 7 out of 10 new replicas have been updated...
# Waiting for deployment nginx-deployment rollout to finish: 7 out of 10 new replicas have been updated...
# Waiting for deployment nginx-deployment rollout to finish: 7 out of 10 new replicas have been updated...
# Waiting for deployment nginx-deployment rollout to finish: 8 out of 10 new replicas have been updated...
# Waiting for deployment nginx-deployment rollout to finish: 8 out of 10 new replicas have been updated...
# Waiting for deployment nginx-deployment rollout to finish: 8 out of 10 new replicas have been updated...
# Waiting for deployment nginx-deployment rollout to finish: 9 out of 10 new replicas have been updated...
# Waiting for deployment nginx-deployment rollout to finish: 9 out of 10 new replicas have been updated...
# Waiting for deployment nginx-deployment rollout to finish: 9 out of 10 new replicas have been updated...
# Waiting for deployment nginx-deployment rollout to finish: 9 out of 10 new replicas have been updated...
# Waiting for deployment nginx-deployment rollout to finish: 3 old replicas are pending termination...
# Waiting for deployment nginx-deployment rollout to finish: 3 old replicas are pending termination...
# Waiting for deployment nginx-deployment rollout to finish: 3 old replicas are pending termination...
# Waiting for deployment nginx-deployment rollout to finish: 2 old replicas are pending termination...
# Waiting for deployment nginx-deployment rollout to finish: 2 old replicas are pending termination...
# Waiting for deployment nginx-deployment rollout to finish: 2 old replicas are pending termination...
# Waiting for deployment nginx-deployment rollout to finish: 1 old replicas are pending termination...
# Waiting for deployment nginx-deployment rollout to finish: 1 old replicas are pending termination...
# Waiting for deployment nginx-deployment rollout to finish: 1 old replicas are pending termination...
# Waiting for deployment nginx-deployment rollout to finish: 8 of 10 updated replicas are available...
# Waiting for deployment nginx-deployment rollout to finish: 9 of 10 updated replicas are available...
# deployment nginx-deployment successfully rolled out

# Have in mind that the image should be provided by your code
# Remenber rollout apply to resource types: deployment, daemonsets, and statefulsets
kubectl rollout
# Manage the rollout of a resource.
#  
# Valid resource types include:
#
#  *  deployments
#  *  daemonsets
#  *  statefulsets
#
# Examples:
#  # Rollback to the previous deployment
#  kubectl rollout undo deployment/abc
#  
#  # Check the rollout status of a daemonset
#  kubectl rollout status daemonset/foo
#
# Available Commands:
#  history     View rollout history
#  pause       Mark the provided resource as paused
#  restart     Restart a resource
#  resume      Resume a paused resource
#  status      Show the status of the rollout
#  undo        Undo a previous rollout
#
# Usage:
#  kubectl rollout SUBCOMMAND [options]
#
# Use "kubectl <command> --help" for more information about a given command.
# Use "kubectl options" for a list of global command-line options (applies to all commands).

