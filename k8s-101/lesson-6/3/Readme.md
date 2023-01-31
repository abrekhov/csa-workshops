##HorizontalPodAutoscaler
```
cd ../3/
```

Let's create ns and limitRange :

```sh
kubectl apply -f 03-ns-limitRange.yaml
```

Let's create deployment and HPA

```sh
kubectl apply -f 03-dep-hpa.yaml
```

Let's run in a window

```sh
watch kubectl get pod,svc,hpa -n demo-ns
```

Sending curl to the IP address of the balancer

```sh
URL=$(kubectl get svc nginx -n demo-ns -o json | jq -r .status.loadBalancer.ingress[0].ip)
while true; do wget -q -O- http://$URL; done
```
Let's release the load


We are waiting for the deployment to scale up and rejoice

Let's see the log

```sh
kubectl describe horizontalpodautoscaler.autoscaling/nginx -n demo-ns
```

```sh
Conditions:
   Type Status Reason Message
   ---- ------ ------ -------
   AbleToScale True ScaleDownStabilized recent recommendations were higher than current one, applying the highest recent recommendation
   ScalingActive True ValidMetricFound the HPA was able to successfully calculate a replica count from cpu resource utilization (percentage of request)
   ScalingLimited True TooManyReplicas the desired replica count is more than the maximum replica count
   ```


   ## Move on to the next lab