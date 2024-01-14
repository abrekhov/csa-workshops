resource "nebius_resourcemanager_folder" "ks_folder" {
  count       = var.folder_id == null ? 1 : 0
  cloud_id    = var.cloud_id
  name        = "${var.cluster_name}-tf"
  description = "See https://github.com/abrekhov/csa-workshops/k8s-101/k8s-tf-template"
}
