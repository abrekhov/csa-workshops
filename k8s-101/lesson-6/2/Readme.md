```
cd ../2/
```

Let's create a deployment with requests and limits:

```sh
kubectl apply -f 02-dep.yaml
```

let's see on which node the application was launched

```
NODENAME=$(kubectl get po -o wide -n demo-ns -o=custom-columns=NAME:.metadata.name,node:.spec.nodeName -o json | jq -r .items[0].spec. nodeName)
kubectl describe node $NODENAME
```

We will see overcommit

```
Allocated resources:
   (Total limits may be over 100 percent, i.e., overcommitted.)
   Resource Request Limits
   -------- -------- ------
   cpu 660m (16%) 50800m (1295%)
   memory 196Mi (7%) 103100Mi (3801%)
   ephemeral-storage 0 (0%) 0 (0%)
Events: <none>
```

Let's look at the neighboring node

```
$ kubectl get nodes
NAME STATUS ROLES AGE VERSION
cl14607bcn1714k4v3im-ahyn Ready <none> 13d v1.17.8

$ kubectl describe node cl14607bcn1714k4v3im-ahyn
```
It has no overcommit

```
Allocated resources:
   (Total limits may be over 100 percent, i.e., overcommitted.)
   Resource Request Limits
   -------- -------- ------
   cpu 610m (15%) 800m (20%)
   memory 132Mi (4%) 700Mi (25%)
   ephemeral-storage 0 (0%) 0 (0%)
```


Let's remove the lab

```
kubectl delete -f 02-dep.yaml
```