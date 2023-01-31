#gatekeeper

```
cd ../3
```

Install Gatekeeper

```
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml

```


Let's create a template to prohibit the use of privileged containers

```
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper-library/master/library/pod-security-policy/privileged-containers/template.yaml
```

  Let's apply it to one demo-ns namespace


  ```

  kubectl apply -f 03-constraint.yaml

  ```

  Let's try to create privileged under

  ```
  kubectl apply -f 03-bad-pod.yaml
  Error from server ([denied by psp-privileged-container] Privileged container is not allowed: nginx, securityContext: {"privileged": true}): error when creating "03-bad-pod.yaml": admission webhook "validation. gatekeeper.sh" denied the request: [denied by psp-privileged-container] Privileged container is not allowed: nginx, securityContext: {"privileged": true}

  ```

  Let's try to create a deployment. Please note that the deployment has been created, but it cannot create pods



```
NAME READY UP-TO-DATE AVAILABLE AGE
deployment.apps/nginx-deployment 0/3 0 0 7s

NAME DESIRED CURRENT READY AGE
replicaset.apps/nginx-deployment-7884d85b4d 3 0 0 7s
```

```
kubectl describe rs
Name: nginx-deployment-7884d85b4d
Namespace:default
...
events:
   Type Reason Age From Message
   ---- ------ ---- ---- -------
   Warning FailedCreate 7s (x14 over 48s) replicaset-controller Error creating: admission webhook "validation.gatekeeper.sh" denied the request: [denied by psp-privileged-container] Privileged container is not allowed: nginx, securityContext: {"privileged" :true}
```

Let's create a good deployment and make sure it works

```
kubectl apply -f 03-good-deploy.yaml
kubectl get all

```



Let's remove the lab

```
kubectl delete all --all
kubectl delete -f 03-constraint.yaml
kubectl delete -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper-library/master/library/pod-security-policy/privileged-containers/template.yaml
kubectl delete -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml
```