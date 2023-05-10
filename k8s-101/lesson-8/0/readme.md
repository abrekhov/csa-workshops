# Helm as a package manager

```bash
cd lesson-8/0
```

Install helm ( https://helm.sh )
For example on Mac

```sh
brew install helm
```

install nginx ingress

```sh
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx
```

Let's look at the result

```sh
kubectl get all
```
