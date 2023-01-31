# Lesson about Service

```
cd ../2/
```

## create namespace and service

```bash
kubectl apply -f 2-ns-svc.yaml
kubectl describe svc nginx -n demo-ns
```

## create a pod with an error

```
kubectl apply -f 2-po-mistake.yaml
```

## we see that endpoints did not appear in describe

We fix under

```
kubectl apply -f 2-po-correct.yaml
```

## we see that endpoints appeared in describe

## create busybox inside default namespace

```bash
kubectl run -i --tty busybox --rm -n default --image=yauritux/busybox-curl --restart=Never -- sh
```

execute a service request from within

```
curl nginx
```

and we can't do anything

we leave

```
exit
```

## create busybox inside service namespace

```
kubectl run -i --tty busybox --rm -n demo-ns --image=yauritux/busybox-curl --restart=Never -- sh
```

execute a service request from within

```
curl nginx #success
```

request successful

we leave

```
exit
```

## remove the namespace

```
kubectl delete ns demo-ns
```