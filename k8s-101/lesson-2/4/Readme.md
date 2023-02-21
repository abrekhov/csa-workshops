# Lesson about nginx ingress controller

```
cd ../4
```

## Install Helm

https://helm.sh/docs/intro/install/#from-homebrew-macos

## Install nginx ingress controller

```sh
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
helm install nginx-ingress nginx-stable/nginx-ingress
```

## Install our test application ( ns + pod + service )

```sh
kubectl apply -f 4-ns-po.yaml
```

## Set the ingress resource

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx
  annotations:
    kubernetes.io/ingress.class: "nginx"
  namespace: demo-ns
spec:
  rules:
    - host: nginx-first.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: nginx
                port:
                  number: 80

```

```sh
kubectl apply -f 4-ingress.yaml
```

## Make requests from the local machine

Calculate the address INGRESS
```sh
kubectl describe svc nginx-ingress-nginx-ingress | grep -e 'LoadBalancer Ingress:' -e 'External Traffic Policy:'
LoadBalancer Ingress: 178.154.247.129
External Traffic Policy: Local
```

Request without hostname will return 404

```sh
curl 178.154.247.129
<html>
<head><title>404 Not Found</title></head>
<body>
```

Request with hostname nginx-first.example.com will give us our pod

```sh
curl -H "Host: nginx-first.example.com" http://178.154.247.129/
<!DOCTYPE html>
<html>
```

## Look at the logs - to see the datapath

### First on ingress

```sh
kubectl get po
NAME READY STATUS RESTARTS AGE
nginx-ingress-nginx-ingress-7ff4fd9bb-kzkqp 1/1 Running 0 12m
```

```sh
kubectl logs nginx-ingress-nginx-ingress-7ff4fd9bb-kzkqp

37.204.229.220 - - [28/Jul/2020:12:54:34 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.54.0" "-"
```
37.204.229.220 is your IP address

### Now in POD

```sh
kubectl logs -n demo-ns pod/nginx

10.160.0.165 - - [28/Jul/2020:12:54:34 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.54.0" "37.204.229.220"
```

10.160.0.165 is the IP address of POD ingres
```sh
kubectl get po -o wide
NAME READY STATUS RESTARTS AGE IP NODE NOMINATED NODE READINESS GATES
nginx-ingress-nginx-ingress-7ff4fd9bb-kzkqp 1/1 Running 0 14m 10.160.0.165 cl197hq2nt1jltu5tmuc-yjyf <none> <none>
```

## Remove the lab

```sh

kubectl delete ns demo-ns

helm uninstall nginx-ingress
```