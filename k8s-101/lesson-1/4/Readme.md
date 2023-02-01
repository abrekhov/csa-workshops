# Lesson about Deployment

```
cd ../4/
```

## create namespace and service

```

kubectl apply -f 4-ns-svc.yaml

kubectl apply -f 4-deploy-v1.yaml
```
We start a request for v1 of the service

```
kubectl run -i --tty busybox --rm -n deploy-ns --image=yauritux/busybox-curl --restart=Never -- sh
```
we carry out from within
```
while true; do curl deployment; done
```
in another tab, update the version and see how the version changes
```
kubectl apply -f 4-deploy-v2.yaml

watch kubectl get po -n deploy-ns
```
## wait until it switches to v2

## roll back
```
kubectl rollout undo deployment kubia -n deploy-ns
```

#wait until we switch to v1

exit busybox
```
exit
```

## remove ns with laba

```
kubectl delete ns deploy-ns
```