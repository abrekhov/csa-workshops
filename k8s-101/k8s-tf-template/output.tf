output "command_to_update_kubeconfig" {
  value = "yc managed-kubernetes cluster get-credentials --id ${yandex_kubernetes_cluster.zonal_cluster.id} --external --force"
}

output "sg-ksmain-ks-public" {
  value = "${yandex_vpc_security_group.ks_public_services.id},${yandex_vpc_security_group.ks_main.id}"
}
