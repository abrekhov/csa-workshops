# Lockbox integration

```bash
yc iam service-account create --name sa-eso
yc iam key create \
  --service-account-name sa-eso \
  --output authorized-key.json
```

```bash
helm repo add external-secrets https://charts.external-secrets.io
helm install external-secrets \
  external-secrets/external-secrets \
  --namespace external-secrets \
  --create-namespace

```

Create secret:

```bash
yc lockbox secret create --name my-secret --payload '[{"key":"PASSWORD","text_value":"p@ssword"}]'
```

Add access bindings for your SA:

```bash
yc lockbox secret add-access-binding \
  --name my-secret \
  --service-account-name sa-eso \
  --role lockbox.payloadViewer
```

Create secret with auth key for SA:

```bash
k create namespace demo-ns
kubectl --namespace demo-ns create secret generic yc-auth \
  --from-file=authorized-key=authorized-key.json
```

Create SecretStore with secretRef to auth key for SA:

```bash
kubectl --namespace demo-ns apply -f - <<<'
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: secret-store
spec:
  provider:
    yandexlockbox:
      apiEndpoint: api.cloudil.com:443
      auth:
        authorizedKeySecretRef:
          name: yc-auth
          key: authorized-key'
```

Create External Secret:

```bash
kubectl --namespace demo-ns apply -f - <<< '
apiVersion: external-secrets.io/v1alpha1
kind: ExternalSecret
metadata:
  name: external-secret
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: secret-store
    kind: SecretStore
  target:
    name: k8s-secret
  data:
  - secretKey: PASSWORD
    remoteRef:
      key: bcn2sm1pvsvhjs66s9f2
      property: PASSWORD'
```

Check secret content:

```bash
kubectl --namespace demo-ns get secret k8s-secret -o jsonpath={.data.PASSWORD} | base64 -d
p@ssword
```
