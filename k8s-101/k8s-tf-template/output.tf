output "command_to_update_kubeconfig" {
  value = "ncp managed-kubernetes cluster get-credentials --id ${nebius_kubernetes_cluster.zonal_cluster.id} --external --force"
}

output "sg-ksmain-ks-public" {
  value = "${nebius_vpc_security_group.ks_public_services.id},${nebius_vpc_security_group.ks_main.id}"
}
