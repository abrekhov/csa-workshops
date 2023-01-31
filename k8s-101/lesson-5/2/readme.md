# Task about Taints and Labels
```
cd ../2
```

## Mark the node with taint

```sh
kubectl get nodes
kubectl taint node cl14607bcn1714k4v3im-ixif app=blue:NoSchedule
kubectl get node cl14607bcn1714k4v3im-ixif -o json | jq .spec.taints
```


Let's deploy the application and make sure that it is not on our node

Window 1
```sh
watch kubectl get po -o wide -n demo-ns -o=custom-columns=NAME:.metadata.name,node:.spec.nodeName
```

Window 2
```sh
kubectl apply -f 01-dep-toleration.yaml
```

Let's give a pod toleration and apply.

```sh
kubectl apply -f 01-dep-toleration.yaml
```

Our application appeared on the desired node and others

## Label the same node with a label

```sh
kubectl get nodes
kubectl label node cl14607bcn1714k4v3im-ixif app=blue
kubectl get node cl14607bcn1714k4v3im-ixif -o json | jq.metadata.labels.app
```

Let's add a nodeSelector to our service

```sh
kubectl deploy nginx -n demo-ns
kubectl apply -f 01-dep-nodeSelector.yaml
```

Our application is deployed only on the node we need


Let's finish the lab

Remove previously assigned taints and labels

```
kubectl taint node cl14607bcn1714k4v3im-ixif app-
kubectl label node cl14607bcn1714k4v3im-ixif app-
```


## Delete namespace with lab
```
kubectl delete ns demo-ns
```