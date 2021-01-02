#!/bin/bash

kubectl get pv
# No resources found

kubectl get persistentvolume
# No resources found

kubectl get persistentvolumes
# No resources found

kubectl apply -f pv-volume-001.yml 
# persistentvolume/pv-volume-001 created

kubectl get pv
# NAME            CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   REASON   AGE
# pv-volume-001   10Gi       RWO            Retain           Available           manual                  3s

# With status volume on "Available" any service could use it.
# We will use it volume trough Claim object.
# We firstly setup the pv volume claim with 20Gi of capacity, so it will force an error because we haven't anyone resource with this description
# If we list the pvc resource we can see that status of deployment is Pending

kubectl get pvc
# No resources found in default namespace.

kubectl apply -f pv-volume-claim.yml 
# persistentvolumeclaim/pv-volume-claim-1 created

kubectl get pvc
# NAME                STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
# pv-volume-claim-1   Pending                                      manual         5s

# It is trying to access type of resouce that doesn't exist
kubectl describe pvc pv-volume-claim-1
# Name:          pv-volume-claim-1
# Namespace:     default
# StorageClass:  manual
# Status:        Pending
# Volume:        
# Labels:        <none>
# Annotations:   <none>
# Finalizers:    [kubernetes.io/pvc-protection]
# Capacity:      
# Access Modes:  
# VolumeMode:    Filesystem
# Used By:       <none>
# Events:
#   Type     Reason              Age               From                         Message
#   ----     ------              ----              ----                         -------
#   Warning  ProvisioningFailed  7s (x6 over 76s)  persistentvolume-controller  storageclass.storage.k8s.io "manual" not found

kubectl delete -f pv-volume-claim.yml 
# persistentvolumeclaim "pv-volume-claim-1" deleted

kubectl get pvc
# No resources found in default namespace.

# Now we edited the capacity need to claim to 9Gi, because the allowed volume has 10Gi.
kubectl apply -f pv-volume-claim.yml 
# persistentvolumeclaim/pv-volume-claim-1 created

# And the status is Bound instead of Pending.
kubectl get pvc
# NAME                STATUS   VOLUME          CAPACITY   ACCESS MODES   STORAGECLASS   AGE
# pv-volume-claim-1   Bound    pv-volume-001   10Gi       RWO            manual         2s

kubectl get pods
# No resources found in default namespace.

kubectl apply -f pv-pod.yml 
# pod/pv-pod created

kubectl get pods
# NAME     READY   STATUS    RESTARTS   AGE
# pv-pod   1/1     Running   0          2s

cat pv-pod.yml | grep mountPath
#        - mountPath: "/usr/share/nginx/html"

kubectl exec -it pv-pod -- bash
exit

kubectl exec -it pv-pod -- bash
mount | grep /usr/share/nginx/html 
# overlay on /usr/share/nginx/html type overlay (rw,relatime,lowerdir=/var/lib/docker/overlay2/l/S5YQENUIVEADQJ73ZQTEF7NVZH:/var/lib/docker/overlay2/l/6UCABQDSKTOPVSPC2SJ6GMNLYR:/var/lib/docker/overlay2/l/C2PJ2DI2ZDD5TNHLIKQQP3PZPD:/var/lib/docker/overlay2/l/545GCQEZVPODIUTEDQCBEM2EMT:/var/lib/docker/overlay2/l/LRMRY4PKY2CHAYYP6FWQTQY6FY:/var/lib/docker/overlay2/l/3YJFZLETNS7WTIS6OSRXPI35R7:/var/lib/docker/overlay2/l/66MCE66B25BWWUSHQR2TTXSYRU:/var/lib/docker/overlay2/l/ER4ROV5HWU7VNI5QQBDW4RWEZP:/var/lib/docker/overlay2/l/74RN3KP7BZVFG3N6M7IV4TSQTC:/var/lib/docker/overlay2/l/VMYCA4SNWGFXI4GJ65MKJKLXRN:/var/lib/docker/overlay2/l/2DUJLZFJTF2J6VYQBYT224UPSI:/var/lib/docker/overlay2/l/URE7D6FJPULRCCOADLLD43JPDR:/var/lib/docker/overlay2/l/OJTJGWMM7LOSIAYPT2LUW7QOKU:/var/lib/docker/overlay2/l/YDQ6B4KJT6ZP4FJSC3UYHJMESL:/var/lib/docker/overlay2/l/BZOWPNBCTXZCWNMF6LT76T3SUV:/var/lib/docker/overlay2/l/NZIJXCQTPAJAAVU4BEZFENLLH6:/var/lib/docker/overlay2/l/DVSPB3RG3X2BW2CDFWUIANKUGT:/var/lib/docker/overlay2/l/ZBJWML5EXFYISV7PBUOVZHWB7O:/var/lib/docker/overlay2/l/A7NJFOJF5OVN36Z76LRU4DHYRU:/var/lib/docker/overlay2/l/BQOARW2UCFW6NZE6MB736LMPG2:/var/lib/docker/overlay2/l/LRYUMU7ZKGFEBEGGVPNQVYX3EA:/var/lib/docker/overlay2/l/2PB5ACM7GO53RVGEN4KLFPW63N:/var/lib/docker/overlay2/l/X43HGJO7DKIE43B3FQ3T5T36LE:/var/lib/docker/overlay2/l/A5NC5R4WWV4N2IDSBOEMCS4ZDQ:/var/lib/docker/overlay2/l/XV5XMSWVKQZ22EVS72F3OILX7U:/var/lib/docker/overlay2/l/UKFDKJ54SOYFM2UGBP4MFO57QQ:/var/lib/docker/overlay2/l/XLXVMASE5KFTBXU27IMQHQQAUQ:/var/lib/docker/overlay2/l/I2RAHY33YAXMAT6HXXJSTTD2KM:/var/lib/docker/overlay2/l/QWNGLEUTW6T7WLCOWXVZKK3HOT:/var/lib/docker/overlay2/l/ZWVG5WYFG4KCM3G4ECKFF3NZE7:/var/lib/docker/overlay2/l/2JIY333CFO3EVW5HM5LYWULUBZ:/var/lib/docker/overlay2/l/2IB5MGC65UCBZUYTHT4JZZL5XO:/var/lib/docker/overlay2/l/CID6XVBGLSFQOKW5STIGJPS5EQ:/var/lib/docker/overlay2/l/BB2FF3TY4753Y4BQUXG5JQWFV4:/var/lib/docker/overlay2/l/HBGPISV2RMUZYHXOBOIJ5LMRTC,upperdir=/var/lib/docker/overlay2/d645881436d33c401ddcc82ba9e7d6ff8c84b0abe5abb5b8d1ebab4476eaba88/diff,workdir=/var/lib/docker/overlay2/d645881436d33c401ddcc82ba9e7d6ff8c84b0abe5abb5b8d1ebab4476eaba88/work,xino=off)
# We can see that have an internal "overlay" type name volume on /usr/share/nginx/html
ls /usr/share/nginx/html
echo hola > /usr/share/nginx/html/index.html 
cat /usr/share/nginx/html/index.html
# hola

touch /nonpersistentfile
exit

kubectl delete -f pv-pod.yml 
# pod "pv-pod" deleted

# I deleted the Pod but no the Volume
kubectl get pv,pvc
# NAME                             CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                       STORAGECLASS   REASON   AGE
# persistentvolume/pv-volume-001   10Gi       RWO            Retain           Bound    default/pv-volume-claim-1   manual                  68m
# 
# NAME                                      STATUS   VOLUME          CAPACITY   ACCESS MODES   STORAGECLASS   AGE
# persistentvolumeclaim/pv-volume-claim-1   Bound    pv-volume-001   10Gi       RWO            manual         19m

# The persistent volume still is here
kubectl apply -f pv-pod.yml 
# pod/pv-pod created

kubectl exec -it pv-pod -- bash
cat /usr/share/nginx/html/index.html 
# hola

cat /nonpersistentfile
# cat: /nonpersistentfile: No such file or directory

# The nonpersistentfile wasn't persisted
# Because this file was wrotten outside of mounted path volume /usr/share/nginx/html
# But no on root path
exit

kubectl delete -f pv-pod.yml 
# pod "pv-pod" deleted

# With Replication resources, ReplicationController, Deployment, in this case an ReplicaSet
kubectl apply -f pv-replicaset.yml 
# replicaset.apps/replicaset-with-volumes created

kubectl get pods
# NAME                            READY   STATUS    RESTARTS   AGE
# replicaset-with-volumes-7c7d6   1/1     Running   0          47s
# replicaset-with-volumes-lgrhn   1/1     Running   0          47s

kubectl exec -it replicaset-with-volumes-7c7d6 -- cat /usr/share/nginx/html/index.html
# hola

kubectl exec -it replicaset-with-volumes-7c7d6 -- cat /nonpersistentfile
# cat: /nonpersistentfile: No such file or directory
# command terminated with exit code 1

kubectl exec -it replicaset-with-volumes-lgrhn -- cat /usr/share/nginx/html/index.html
# hola

kubectl exec -it replicaset-with-volumes-lgrhn -- cat /nonpersistentfile
# cat: /nonpersistentfile: No such file or directory
# command terminated with exit code 1

# We can acccess to same data on the persistent volume from different pods, so place the source code here is agood idea.
kubectl delete -f pv-replicaset.yml 
# replicaset.apps "replicaset-with-volumes" deleted
# Through pv-volume-001 we defined an persisten volume, but it isn't on our local machine directly, it is on minikube cluster
cat pv-volume-001.yml | grep path
#     path: "/mnt/data/pv-volume-001"

cd /mnt/data/pv-volume-001
# bash: cd: /mnt/data/pv-volume-001: No such file or directory

minikube ssh
# Last login: Sat Jan  2 19:35:52 2021 from 192.168.49.1

ls /mnt/data/pv-volume-001
# index.html

cat index.html 
# hola

# If we need to backup, we should perform it from it mount point to worker nodes.
logout

# If you try to delete an volume being use by other Pod, It will be blocked until the volume be free.
# In other words you can't delete an volumen when is claimed.
kubectl delete -f pv-volume-001.yml 
# persistentvolume "pv-volume-001" deleted
# ^C

# We can see the status is Terminating, but it no will finish until claims was deleted
kubectl get pv,pvc
# NAME            CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS        CLAIM                       STORAGECLASS   REASON   AGE
# pv-volume-001   10Gi       RWO            Retain           Terminating   default/pv-volume-claim-1   manual                  85m
# 
# NAME                STATUS   VOLUME          CAPACITY   ACCESS MODES   STORAGECLASS   AGE
# pv-volume-claim-1   Bound    pv-volume-001   10Gi       RWO            manual         37m

kubectl delete -f pv-volume-claim.yml 
# persistentvolumeclaim "pv-volume-claim-1" deleted

# And then persistent volume was deleted too.
kubectl get pv
# No resources found

