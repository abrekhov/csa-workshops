# SA for NS

```
cd ../2
```
Pull out the cluster ID (useful later)

```
yc managed-kubernetes cluster list
$CLUSTER_ID=cateqfn1s7fupiu9bo48
```
Pull out the CA certificate of the cluster

```
yc managed-kubernetes cluster get --id $CLUSTER_ID --format json | \
     jq -r .master.master_auth.cluster_ca_certificate | \
     awk '{gsub(/\\n/,"\n")}1' > ca.pem
```

Create SA - cluster admin

```
kubectl create -f sa.yaml
```
Pull out his authentication token
```
SA_TOKEN=$(kubectl -n kube-system get secret $(kubectl -n kube-system get secret | \
     grep admin-user | \
     awk '{print $1}') -o json | \
     jq -r .data.token | \
     base64 --d)



```

Find the address of the master


```
MASTER_ENDPOINT=$(yc managed-kubernetes cluster get --id $CLUSTER_ID \
     --format json | \
     jq -r .master.endpoints.external_v4_endpoint)
echo $MASTER_ENDPOINT
```

create a configuration file

```
kubectl config set-cluster sa-test2 \
                --certificate-authority=ca.pem \
                --server=$MASTER_ENDPOINT \
                --kubeconfig=test.kubeconfig
```

add creds to it

```
kubectl config set-credentials admin-user \
                 --token=$SA_TOKEN \
                 --kubeconfig=test.kubeconfig
```

add a cluster to it

```
kubectl config set-context default \
                --cluster=sa-test2 \
                --user=admin-user \
                --kubeconfig=test.kubeconfig
```

make this context default in this file

```
kubectl config use-context default \
                --kubeconfig=test.kubeconfig
```

take a look at the cluster

```
kubectl get namespace --kubeconfig=test.kubeconfig
```

Let's clean the lab

```
rm ca.pem
rm test.kubeconfig
```

and lastly

change the namespace of the current context

```
kubectl config current-context
kubectl config set-context --current --namespace=kube-system
kubectl get all
kubectl config set-context --current --namespace=default
```