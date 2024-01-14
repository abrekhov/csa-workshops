# Managed K8s template

## Quickstart

#. (if needed) Activate the NCP Profile with `ncp config profile activate <profile-name>`
#. Create a token through `export NCP_TOKEN=$(ncp iam create-token)`
#. Run:
```bash
terraform init
terraform plan -var cloud_id=$(ncp config get cloud-id)
terraform apply -auto-approve -var cloud_id=$(ncp config get cloud-id)
```
