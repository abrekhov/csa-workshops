# POD lesson

```bash
cd 1/
```

## create under

```bash
kubectl apply -f 1-nginx.yaml
```

## look at the status (in two tabs)

```bash
watch kubectl get po -o wide
watch kubectl get node -o wide
```

## remove the node that has a pod

## pod is gone but we're not sad, we're moving on
