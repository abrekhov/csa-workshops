# Certificates and secrets


cd ../3/



## Install Helm

https://helm.sh/docs/intro/install/#from-homebrew-macos

## Install nginx ingress controller

```sh
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
helm install nginx-ingress nginx-stable/nginx-ingress
```

write down the IP address of the balancer
```sh
watch kubectl get svc nginx-ingress-nginx-ingress # wait for the IP address
INGRESS_IP=$(kubectl get svc nginx-ingress-nginx-ingress --output=json | jq -r .status.loadBalancer.ingress[0].ip)
```

# Create a test application and publish to the Internet with only port 80

```sh
kubectl create -f 03-ns-pod-svc.yaml
curl -H "Host: test.example" http://${INGRESS_IP}/ #should return a page with nginx
```
# Create and import a test certificate

```sh
HOST=test.example
CERT_NAME=test.example
KEY_FILE=cert.key
CERT_FILE=cert.crt
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${KEY_FILE} -out ${CERT_FILE} -subj "/CN=${HOST}/O=${HOST}"
kubectl create secret tls ${CERT_NAME} --key ${KEY_FILE} --cert ${CERT_FILE} -n demo-ns
```

# connect the certificate with ingress


```sh
kubectl apply -f 03-cert-ingress.yaml
```

Check that the test.example host issues the generated certificate

```sh
$echo | openssl s_client -showcerts -servername test.example -connect ${INGRESS_IP}:443 2>/dev/null | openssl x509 -inform pem -noout -text | grep Subject:
         Subject: CN=test.example, O=test.example
```
Check that another host is issuing a default certificate



```sh
$echo | openssl s_client -showcerts -servername testdude.example -connect ${INGRESS_IP}:443 2>/dev/null | openssl x509 -inform pem -noout -text | grep Subject:
         Subject: CN=NGINXIngressController
```

# Do not delete the lab - go to the lab 4