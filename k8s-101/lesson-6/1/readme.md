# probes

```
cd lesson-6/1
```

Let's create a deployment with samples:

```sh
kubectl apply -f 01-dep.yaml
```

Launch an app search in the background
```
watch kubectl describe svc -n demo-ns
```

Sending curl to the IP address of the balancer

```
URL=$(kubectl get svc probe -n demo-ns -o json | jq -r '.status.loadBalancer.ingress[0].ip')
curl $URL/healthz
```


1) at first it will not come (because the node has not become ready yet)
2) after 30 seconds, nodes will appear in Endpoints and requests will start coming
3) in a minute, requests will stop coming at all and the nodes will be sold from the endpoint

4) look at the logs what happened

```
kubectl describe po -n demo-ns
```

We will see messages about problems with the readiness probe


Let's remove the lab

```
kubectl delete -f 01-dep.yaml
```