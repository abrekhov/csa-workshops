# PVC

```
cd ../2/
```

Let's create `PVC` and under c nginx :

Using storageClass

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
   name: pvc dynamic
   namespace: demo-ns
spec:
   accessModes:
     - ReadWriteOnce
   storageClassName: yc-network-ssd
   resources:
     requests:
       storage: 16Gi
```

POD
```yaml
---
apiVersion: v1
kind: Pod
metadata:
   name: nginx
   namespace: demo-ns
   labels:
     app: nginx
spec:
   containers:
   - name: nginx
     image: nginx
     volumeMounts:
     -name: persistent-storage
       mountPath: /usr/share/nginx/html
   volumes:
   -name: persistent-storage
     persistentVolumeClaim:
       claimName: pvc-dynamic
```

```sh
kubectl apply -f 02-ns-pvc.yaml

kubectl apply -f 02-pod-svc.yaml

watch kubectl get all -n demo-ns #we won't see PV

SVC_IP=<ADDRESS> #write your address here

curl $SVC_IP

```

###

Change `nginx content` :

```sh

kubectl exec -it nginx -n demo-ns bash

echo "test" > /usr/share/nginx/html/index.html

kubectl delete po/nginx -n demo-ns

```

Remove and restart pod :


```sh
kubectl delete po/nginx -n demo-ns

kubectl apply -f 02-pod-svc.yaml

curl $SVC_IP #see test written to disk

```


Let's clean up the lab

```sh
  kubectl delete ns demo-ns
  ```