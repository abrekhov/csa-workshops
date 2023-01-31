# Helm as a package manager

```
cd lesson-9/0
```

Install helm ( https://helm.sh )
For example on Mac

```sh
brew install helm
```

install nginx ingress

```sh
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
helm install nginx-ingress nginx-stable/nginx-ingress
```

Let's look at the result

```sh
kubectl get all
```