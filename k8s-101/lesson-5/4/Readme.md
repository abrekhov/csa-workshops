# Lesson about Pod-AntiAffinity

```
cd ../4/
```

## create namespace and service

```
kubectl apply -f 4-ns-svc.yaml

kubectl apply -f 4-deploy-req.yaml
```

Run in window 1
```
watch kubectl get pods -n demo-ns -o wide -o=custom-columns=NAME:.metadata.name,node:.spec.nodeName
```

We see that we can deploy as many pods as there are hosts.
Now let's change the required condition (`requiredDuringSchedulingIgnoredDuringExecution`) to wish (`preferredDuringSchedulingIgnoredDuringExecution`)

```
kubectl delete -f 4-deploy-req.yaml
kubectl apply -f 4-deploy-prefer.yaml
```
We see that there are more pods

## Delete namespace with lab
```
kubectl delete ns demo-ns
```