# Configmap

```
cd 1/
```

Let's create a `configmap ` and an application:

Composition of ConfigMap
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
   name: nginx
   namespace: demo-ns

data:
   # Adding new entries here will make them appear as files in the deployment.
   # Please update k8s.io/k8s.io/README.md when you update this file
   nginx.conf: |
     worker_processes auto;
     events {
     }

     http {
       server {
         listen 80 ;
         location = /_healthz {
           add_header Content-Type text/plain;
           return 200 'ok';
         }
         location / {
           add_header Content-Type text/plain;
           return 200 'Hello World!<br/>';
         }
       }
     }
```

```sh
kubectl apply -f 01-cm-start.yaml

kubectl get svc -n demo-ns

SVC_IP=<ADDRESS> #write your address here

for i in $(seq 1 10); do curl $SVC_IP ;done

```

###

Change `configmap ` :

```sh
kubectl apply -f 01-cm-new.yaml

for i in $(seq 1 10); do curl $SVC_IP ;done


```

Nothing changed

### Let's restart under

```sh
kubectl get po -n demo-ns


kubectl delete po nginx-cd89cd796-kl967 -n demo-ns

for i in $(seq 1 10); do curl $SVC_IP ;done
```

Now it's changed


Let's clean up the lab

```sh
kubectl delete -f 01-cm-start.yaml
```