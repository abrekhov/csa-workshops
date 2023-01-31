# network-policy

```bash
cd 1/
```

Example

There are 3 namespaces - `default`, `prod`, `dev`. We want pods from namespace `prod` to be able to go to our application, which is deployed in namespace `default`, and from `dev`, respectively, could not

Let's deploy the web server to default:

```sh
kubectl run web --image=nginx --labels=app=web --expose --port 80
```

Create `prod` , `dev` namespaces:

```sh
kubectl create namespace dev
kubectl label namespace/dev purpose=testing
```

```sh
kubectl create namespace prod
kubectl label namespace/prod purpose=production
```

### Let's try

Let's make a request from `dev` it will pass:

```sh
$ kubectl run --generator=run-pod/v1 test-$RANDOM --namespace=dev --rm -i -t --image=alpine -- sh
If you dont see a command prompt, try pressing enter.
/ # wget -qO- --timeout=2 http://web.default
<!DOCTYPE html>
<html>
<head>
```

```
exit
```

Run the network policy file ( 01-web-allow-prod.yaml )

```yaml
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
   name: web-allow-prod
spec:
   selector:
     match Labels:
       app: web
   input:
   -from:
     -namespaceSelector:
         match Labels:
           purpose: production
```

```sh
$ kubectl apply -f 01-web-allow-prod.yaml
networkpolicy "web-allow-prod" created
```


Let's make a request from `dev` it will not pass:

```sh
$ kubectl run --generator=run-pod/v1 test-$RANDOM --namespace=dev --rm -i -t --image=alpine -- sh
If you dont see a command prompt, try pressing enter.
/ # wget -qO- --timeout=2 http://web.default
wget: download timed out
(traffic blocked)

```

Let's make a request from `prod` it will pass:

```sh
$ kubectl run --generator=run-pod/v1 test-$RANDOM --namespace=prod --rm -i -t --image=alpine -- sh
If you don't see a command prompt, try pressing enter.
/ # wget -qO- --timeout=2 http://web.default
<!DOCTYPE html>
<html>
<head>
...
(traffic allowed)
```

### Let's finish

```bash
     kubectl delete networkpolicy web-allow-prod
     kubectl delete pod web
     kubectl delete service web
     kubectl delete namespace {prod,dev}
```

### Lots of examples here

https://github.com/ahmetb/kubernetes-network-policy-recipes