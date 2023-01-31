# SA for pod

```
cd ../2
```

Run the pod with default SA first

```
kubectl apply -f 02-pod-default-sa.yaml
```

Please note that the default secret SA is mounted to the pod.


```

kubectl get po curl -o yaml

apiVersion: v1
kind: Pod
...
spec:
   containers:
   - image: yauritux/busybox-curl
     ...
     volumeMounts:
     - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
       name: default-token-b9xbs
       readOnly: true
..
   volumes:
   -name: default-token-b9xbs
     secret:
       defaultMode: 420
       secretName: default-token-b9xbs
...

```

Let's go to the pod and try to make requests to the kubernetes api from it

```
kubectl exec -ti curl -- sh
apk add curl
```

no token at all
```
curl https://kubernetes/api/v1 --insecure
{
   "kind": "status",
   "apiVersion": "v1",
   metadata: {

   },
   "status": "Failure",
   "message": "forbidden: User \"system:anonymous\" cannot get path \"/api/v1\"",
   "reason": "Forbidden",
   "details": {

   },
   code: 403
```

with a default token is already better

```
TOKEN=$(cat /run/secrets/kubernetes.io/serviceaccount/token)
/ # curl -H “Authorization: Bearer $TOKEN” https://kubernetes/api/v1/ --insecure
Let's create an SA inside the k8s cluster and make it an admin:
```
But for example, you can’t scroll through the pods

```
curl -H "Authorization: Bearer $TOKEN" https://kubernetes/api/v1/namespaces/default/pods/ --insecure
{
   "kind": "status",
   "apiVersion": "v1",
   metadata: {

   },
   "status": "Failure",
   "message": "pods is forbidden: User \"system:serviceaccount:default:default\" cannot list resource \"pods\" in API group \"\" in the namespace \"default\"",
   "reason": "Forbidden",
   "details": {
     "kind": "pods"
   },
   code: 403

```

Let's create a new SA (admin) and pod with it

```
kubectl apply -f 02-sa.yaml
kubectl apply -f 02-pod-admin-sa.yaml
```

Let's go to the pod and try to make requests to the kubernetes api from it

```
kubectl exec -ti curl-admin --sh
apk add curl
```

Now we can leaf through the pods

```
TOKEN=$(cat /run/secrets/kubernetes.io/serviceaccount/token)
curl -H "Authorization: Bearer $TOKEN" https://kubernetes/api/v1/namespaces/default/pods/ --insecure
```

Let's finish the lab

```
kubectl delete all --all
```