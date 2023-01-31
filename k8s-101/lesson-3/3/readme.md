# NFS

```
cd ../3/
```

Let's create a storageClass :

```sh
helm repo add stable https://charts.helm.sh/stable

helm install nfs stable/nfs-server-provisioner --set=persistence.enabled=True,persistence.size=33Gi,persistence.storageClass='yc-network-ssd'


watch kubectl get po,svc,pvc,pv


```

###

Let's change `start a pair of pods with shared storage ` :

```sh

kubectl apply -f 03-ns-pvc.yaml
kubectl apply -f 03-pod-svc.yaml

watch kubectl get po,svc,pvc -n demo-ns

SVC_IP=<ADDRESS> #write your address here

for i in $(seq 1 10); do curl $SVC_IP ;done

```

Let's cure the pods:


```sh
kubectl exec -it nfs-nfs-server-provisioner-0 bash

  ls -l /export/

echo "test" > /export/pvc-0e53727f-9a06-4a4d-b32a-576076176a62/index.html

exit

for i in $(seq 1 10); do curl $SVC_IP ;done

```


Let's clean up the lab

```sh
  kubectl delete ns demo-ns
  helm uninstall nfs
  kubectl delete pvc data-nfs-nfs-server-provisioner-0

```