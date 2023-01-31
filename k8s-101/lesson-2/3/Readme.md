# Lesson about Load Balancer

```
cd ../3/
```

## Create test namespace and deployment
```sh
kubectl apply -f 3-ns-po.yaml
```

## make a service with type load-balancer
```sh
kubectl apply -f 3-svc-default.yaml

```

## pull out the IP address of the created Service , and type ( Cluster) d

```sh
$ kubectl describe service/nginx -n demo-ns | grep -e 'LoadBalancer Ingress:' -e 'External Traffic Policy:'
LoadBalancer Ingress: 178.154.246.204
External Traffic Policy: Cluster
```

Making a test request (you will have your own address)

```sh
$ curl 178.154.246.204
<!DOCTYPE html>
<html>
<head>
```
## look at the logs

```sh
$ kubectl logs -n demo-ns pod/nginx
10.100.0.36 - - [28/Jul/2020:12:14:12 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.54.0" "-"
```
10.100.0.36 is the IP address of one of the nodes

```sh
$ kubectl get nodes -o wide | grep 10.100.0.36
cl197hq2nt1jltu5tmuc-yjyf Ready <none> 110m v1.16.6-1+a69a9f20ae9b5d 10.100.0.36 130.193.50.15 Ubuntu 18.04.3 LTS 4.15.0-55-generic docker://18.6.2
```

## change External Traffic Policy to Local

```sh
kubectl apply -f 3-svc-local.yaml

```


```sh
$ kubectl describe service/nginx -n demo-ns | grep -e 'LoadBalancer Ingress:' -e 'External Traffic Policy:'
LoadBalancer Ingress: 178.154.246.204
External Traffic Policy: Local
```

Making a test request

```sh
nrkk-osx:2 nrkk$ curl 178.154.246.204
<!DOCTYPE html>
<html>
<head>
```
## look at the logs

```sh
$ kubectl logs -n demo-ns pod/nginx
37.204.229.220 - - [28/Jul/2020:12:25:59 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.54.0" "-"
```
37.204.229.220 is the IP address of one of the nodes

```sh
$ curl -4 ifconfig.io #Need to do without our VPN
37.204.229.220
```

## remove the namespace
```sh
kubectl delete ns demo-ns
```