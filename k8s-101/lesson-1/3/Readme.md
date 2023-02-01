# Lesson: ReplicaSet

```
cd ../3/
```

## create under

```
kubectl apply -f 3-nginx-rs.yaml
```

## look at the status
```
watch kubectl get po -o wide
watch kubectl get rs
```
## remove the node that has a pod

## Pod is gone and ReplicaSet will restore it

we complete the lab
```
kubectl delete rs nginx
kubectl delete svc nginx

```