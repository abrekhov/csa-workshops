# user from iam

```
cd lesson-7/1
```

Let's create SA in our folder and don't give it any roles:

```sh
yc iam service-account create --name=sa-user
export SERVICE_ACCOUNT_ID=`yc iam service-account get sa-user --format json | jq -rMc '.id'`
```

Pull out its id (it will come in handy later)

```sh
yc iam service-account get --name=sa-user --format=json | jq -r .id
yc resource-manager folder add-access-binding --service-account-name=sa-user --role=viewer --id=$( yc config get folder-id)
```

Let's create a yc profile with this sa

```sh
yc iam key create --service-account-name=sa-user --output=sa-key.json
export CLOUD_ID=`yc config get cloud-id` # use for new profile
export FOLDER_ID=`yc config get folder-id` # use for new profile
yc config profile create sa-user
yc config set service-account-key sa-key.json
yc config set cloud-id $CLOUD_ID
yc config set folder-id $FOLDER_ID
yc config set endpoint api.cloudil.com:443
```

Let's create a profile for such a user

```sh
export CLUSTER_ID=`yc managed-kubernetes cluster list --format json | jq -rMc '.[0].id'`
export CONTEXT=`kubectl config current-context` # remember , useful later
yc managed-kubernetes cluster get-credentials --context-name=$CONTEXT --id $CLUSTER_ID --profile=sa-user --force --external
```

let's try to populate the nodes

and we won't get anything

```sh
kubectl get nodes
Error from server (Forbidden): nodes is forbidden: User "ajejaknpv691pncogst5" cannot list resource "nodes" in API group "" at the cluster scope
```

give roles within the cluster

```sh
yc managed-kubernetes cluster get-credentials --context-name=$CONTEXT --id $CLUSTER_ID --profile=cloudil --force --external
```

fill in the file id 01-CRB.yaml id SA in the user field and apply

```bash
kubectl apply -f 01-CRB.yaml
yc managed-kubernetes cluster get-credentials --context-name=$CONTEXT --id $CLUSTER_ID --profile=sa-user --force --external
```

Now everything works out

```bash
kubectl get nodes
NAME STATUS ROLES AGE VERSION
cl1a8efj57gn5ccs1gfv-ujiq Ready <none> 14d v1.17.8
cl1fu7golamsfv2f3to0-ojeh Ready <none> 14d v1.17.8
cl1tbgmha61b3u1tc52n-ipuj Ready <none> 6d21h v1.17.8
```

back to main profile

```bash
yc managed-kubernetes cluster get-credentials --context-name=$CONTEXT --id $CLUSTER_ID --profile=cloudil --force --external
kubectl delete -f 01-CRB.yaml
```
