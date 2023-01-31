# Lesson about RollingUpdate

```
cd ../3/
```

## create namespace and service

```
kubectl apply -f 3-ns-svc.yaml

kubectl apply -f 3-deploy-v1.yaml
```

Run in window 1

```
watch kubectl get pods -n deploy-ns -o wide -o=custom-columns=NAME:.metadata.name,node:.spec.nodeName
```

In window 2 we execute

```
kubectl apply -f 3-deploy-v2.yaml
```

We see that the pods are added one at a time.


## Delete namespace with lab
```
kubectl delete ns deploy-ns
```