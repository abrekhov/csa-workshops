#Cert Manager

## !Before this lab, you must complete the previous one!



cd ../4/



## Set up DNS to make everything work

In general, it is necessary that your domain name be resolved on the Internet to the address of the ingress controller - $INGRESS_IP

For example, I will use the k-101.app.nrk.me.uk domain, which resolves to 84.201.128.53

```sh
nrkk-osx:3 nrkk$ echo $INGRESS_IP
84.201.128.53
nrkk-osx:3 nrkk$ dig k-101.app.nrk.me.uk | grep $INGRESS_IP
k-101.app.nrk.me.uk. 299 IN A 84.201.128.53
```
## Install cert-manager


```sh
kubectl create namespace cert-manager
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v0.16.1 --set installCRDs=true
watch kubectl get pods --namespace cert-manager
```
## Install ACME issuer - it will issue honest certificates

write down your email variable and create a file based on this for the ClusterIssuer resource

```sh
EMAIL=<YOUR_EMAIL> # for example nar3k1@gmail.com
cat 04-acme-prod-issuer.yaml.tpl | sed 's/'"<EMAIL>"'/'"$EMAIL"'/' > 04-acme-issuer.yml
kubectl apply -f 04-acme-issuer.yml
```

Let's create and run ingress on our domain name

```sh
DOMAIN_NAME=<Your domain name> # e.g. k-101.app.nrk.me.uk
cat 04-acme-ingress.yaml.tpl | sed 's/'"<DOMAIN_NAME>"'/'"$DOMAIN_NAME"'/' > 04-acme-ingress.yml
kubectl apply -f 04-acme-ingress.yml
```

We are waiting for our certificate to be successfully issued


```sh
nrkk-osx:4 nrkk$ kubectl describe certificate echo-tls -n demo-ns

events:
   Type Reason Age From Message
   ---- ------ ---- ---- -------
   Normal Issuing 44s cert-manager Issuing certificate as Secret does not exist
   Normal Generated 44s cert-manager Stored new private key in temporary Secret resource "echo-tls-48w44"
   Normal Requested 44s cert-manager Created new CertificateRequest resource "echo-tls-zhs74"
   Normal Issuing 4s cert-manager The certificate has been successfully issued
```

Checking
```sh
nrkk-osx:4 nrkk$ echo | openssl s_client -showcerts -servername ${DOMAIN_NAME} -connect ${DOMAIN_NAME}:443 2>/dev/null | openssl x509 -inform pem -noout -text | grep Subject:
         Subject: CN=k-101.app.nrk.me.uk:

```

You can also check with your browser :)

## Clean up the lab


```sh
kubectl delete ns demo-ns
helm uninstall nginx-ingress
helm uninstall cert-manager --namespace cert-manager
```