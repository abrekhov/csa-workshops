# Lesson about Service

```
cd ../2/
```
## create a namespace
```
kubectl create namespace demo-ns
```

## trying to knock on a non-existent service inside the Neuspace
```sh
kubectl run -i --tty busybox -n demo-ns --image=yauritux/busybox-curl --restart=Never
/home # curl nginx
curl: (6) Couldnt resolve host nginx.demo-ns
/home # curl nginx.demo-ns
curl: (6) Couldnt resolve host nginx.demo-ns
```
Please note - when there is no service, it does not resolve by any name


## make a service without pods (endpoints)
```
kubectl apply -f 2-svc.yaml
```

## we see that endpoints did not appear in describe

```sh
$ kubectl describe service/nginx -n demo-ns | grep Endpoints
Endpoints: <none>
```
## trying to knock on the service inside the netspace without a pod

```sh
/home # wget -qO- --timeout=2 http://nginx.demo-ns.svc.cluster.local
wget: download timed out
/home # wget -qO- --timeout=2 http://nginx
wget: download timed out
```

Pay attention - when there is a service, but there are no pods, then we see timeouts (as in network-policy ) or sometimes connection refused

## add a pod to the service
```
kubectl apply -f 2-pod.yaml
```


## we see that endpoints appeared in describe
```sh
nrkk-osx:2 nrkk$ kubectl describe service/nginx -n demo-ns | grep Endpoints

Endpoints: 10.160.0.152:80
```

## we try to knock on the hearth inside the Neuspace and everything is fine with us

```sh
/home # wget -qO- --timeout=2 http://nginx.demo-ns
<!DOCTYPE html>
<html>
<head>
```

## remove the namespace
```
kubectl delete ns demo-ns
```