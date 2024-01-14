# Managed K8s template

## Quickstart

1. (if needed) Activate the NCP Profile with `ncp config profile activate <profile-name>`
2. Create a token through `export NCP_TOKEN=$(ncp iam create-token)`
3. Run:
```bash
terraform init
terraform plan -var cloud_id=$(ncp config get cloud-id)
terraform apply -auto-approve -var cloud_id=$(ncp config get cloud-id)
```
