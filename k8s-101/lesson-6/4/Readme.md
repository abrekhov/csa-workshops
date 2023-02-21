## ClusterAutoScaler
```
cd ../4/
```

### Run lab 3

Make sure we have a cluster with autoscaling

Remove HPA

```sh
kubectl delete horizontalpodautoscaler.autoscaling/nginx -n demo-ns
```

Let's see that we initially have 2 nodes

We will see that the nodes have increased

```sh
kubectl get nodes
NAME STATUS ROLES AGE VERSION
cl1a8efj57gn5ccs1gfv-iwuw Ready <none> 74s v1.17.8
cl1a8efj57gn5ccs1gfv-okic Ready
```

Let's create a deployment with 10 copies

```sh
kubectl apply -f 04-dep.yaml
```

Find a pod in the Pending status


```sh
kubectl get po -n demo-ns
NAME READY STATUS RESTARTS AGE
nginx-fb59c6944-2ppgl 0/1 Pending 0 4s
```

Let's take a look at his log.

```sh
kubectl describe po nginx-fb59c6944-525nm -n demo-ns
```

```sh

events:
   Type Reason Age From Message
   ---- ------ ---- ---- -------
   Normal TriggeredScaleUp 2m48s cluster-autoscaler pod triggered scale-up: [{catt4okekqmpj8pn90ei 1->3 (max: 3)}]
   Warning FailedScheduling 113s (x3 over 2m54s) default-scheduler 0/4 nodes are available: 4 Insufficient pods.
   Warning FailedScheduling 32s (x3 over 37s) default-scheduler 0/5 nodes are available: 1 node(s) had taints that the pod didn't tolerate, 4 Insufficient pods.
   Warning FailedScheduling 19s (x3 over 28s) default-scheduler 0/6 nodes are available: 2 node(s) had taints that the pod didn't tolerate, 4 Insufficient pods.
   Normal Scheduled 8s default-scheduler Successfully assigned demo-ns/nginx-fb59c6944-525nm to cl1a8efj57gn5ccs1gfv-iwuw
   Normal Pulling 6s kubelet, cl1a8efj57gn5ccs1gfv-iwuw Pulling image "k8s.gcr.io/hpa-example"
```

We will see that the nodes have increased

```sh
kubectl get nodes
NAME STATUS ROLES AGE VERSION
cl1a8efj57gn5ccs1gfv-iwuw Ready <none> 74s v1.17.8
cl1a8efj57gn5ccs1gfv-okic Ready <none> 79s v1.17.8
cl1a8efj57gn5ccs1gfv-ujiq Ready <none> 42m v1.17.8
cl1fu7golamsfv2f3to0-axen Ready <none> 20m v1.17.8
cl1fu7golamsfv2f3to0-ojeh Ready <none> 43m v1.17.8
cl1fu7golamsfv2f3to0-upum Ready <none> 12m v1.17.8
```
Remove Lab

```sh
kubectl delete ns demo-ns
```