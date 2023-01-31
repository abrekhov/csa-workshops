# Deployment and PVC
```
cd lesson-4/1
```

Let's create pvc and deployment with nginx :

```sh

kubectl apply -f 01-ns-pvc.yaml
kubectl apply -f 01-dep.yaml
```

Let's look into the pod and write a file to it
```sh
kubectl get po -n demo-ns
kubectl exec -it nginx-<HASH> /bin/bash -n demo-ns
```
inside the pod execute first

```sh
curl localhost
```
We get 403 (because there is no index.html file)

write index.html file
```
echo "test" > /usr/share/nginx/html/index.html
curl localhost # will successfully give us test
```

delete deployment and recreate

```
kubectl delete -f 01-dep.yaml
kubectl apply -f 01-dep.yaml
kubectl get po -n demo-ns
kubectl exec -it nginx-<HASH> /bin/bash -n demo-ns
curl localhost # will successfully issue test
```

The deployment was recreated, but the data disk remained. In general, you can raise single host services in deployment (for example, bases) and there will be nothing to worry about.

But the problems start when we scale such a deployment
```sh
kubectl scale deployment nginx --replicas=2 -n demo-ns
```

see this picture

```sh
nrkk-osx:1 nrkk$ kubectl get po -n demo-ns
NAME READY STATUS RESTARTS AGE
nginx-5984b8457-88qzg 1/1 Running 0 35m
nginx-5984b8457-s5blg 0/1 ContainerCreating 0 33m
```

```sh
nrkk-osx:1 nrkk$ kubectl describe po nginx-5984b8457-s5blg -n demo-ns
...
   Warning FailedAttachVolume 33m attachdetach-controller Multi-Attach error for volume "pvc-4ff05376-46e2-4f34-9caa-2e67e387cc46" Volume is already used by pod(s) nginx-5984b8457-88qzg
```

The second Pod tries to attach the same PVC, and it doesn't work as expected (because it's ReadWriteOnce)

Clean up the lab to move on

```sh
kubectl delete ns demo-ns
```