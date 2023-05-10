# Helm as a package manager

```
cd ../1
```


Create a chart from a template

```
helm create mychart
```
Let's see what's inside and then create a chart

```
kubectl create namespace demo-ns
kubectl config set-context --current --namespace demo-ns
helm install helm-test mychart/
helm ls
```

Already 2 charts

Let's see what has been created

```
kubectl get all --show-labels
```

Let's add autoscaling to the application manually.
Let's see how to turn it on first.

```
cat mychart/templates/hpa.yaml
cat mychart/values.yaml
```

Let's see how the manifests with autoscaling enabled and disabled differ

```
helm upgrade helm-test mychart/ --dry-run

helm upgrade --set autoscaling.enabled=true helm-test mychart/ --dry-run
```

we see that HPA appeared here
```
# Source: mychart/templates/hpa.yaml
apiVersion: autoscaling/v2beta1
kind: HorizontalPodAutoscaler
metadata:
   name: helm-test-mychart
   labels:
     helm.sh/chart:mychart-0.1.0
     app.kubernetes.io/name: mychart
     app.kubernetes.io/instance: helm-test
     app.kubernetes.io/version: "1.16.0"
     app.kubernetes.io/managed-by: Helm
spec:
   scaleTargetRef:
     apiVersion: apps/v1
     kind: Deployment
     name: helm-test-mychart
   minReplicas: 1
   maxReplicas: 100
   metrics:
     - type: Resource
       resource:
         name: cpu
         targetAverageUtilization
```

create

```
helm upgrade --set autoscaling.enabled=true helm-test mychart/
```

But it's not very pretty, especially when you need to pass a lot of variables. Let's try to pass a complex config

```
helm upgrade --values new-values.yaml helm-test mychart/ --dry-run
```

we see that ingress appeared here (and HPA remained)

```
helm upgrade --values new-values.yaml helm-test mychart/
kubectl get deploy,hpa,ingress,svc
```

Check ingress

```bash
EXTERNAL_IP=`kubectl get svc ingress-nginx-controller -o json | jq -rMc '.status.loadBalancer.ingress[0].ip'`
curl -H 'Host: chart-example.local' $EXTERNAL_IP
```

Let's finish the lab

```bash
helm uninstall helm-test
helm uninstall nginx-ingress
kubectl delete all --all
rm -rf mychart/
```
