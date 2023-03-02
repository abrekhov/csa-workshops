# Managed K8s template

## Quickstart

1. Auth with yc cli
1. Substitute net_id and cluster name in `init-env.sh`

```bash
make plan
make apply

# or manually
source init-env.sh
terraform apply -auto-approve
```
