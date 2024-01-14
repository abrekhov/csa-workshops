resource "nebius_iam_service_account" "ks-res-sa" {
  folder_id   = var.folder_id != null ? var.folder_id : nebius_resourcemanager_folder.ks_folder[0].id
  name        = "ks-res-sa"
  description = "Service account for K8s resources"
}

resource "nebius_resourcemanager_folder_iam_member" "ks-res-sa-editor" {
  folder_id = nebius_iam_service_account.ks-res-sa.folder_id
  role      = "editor"
  member    = "serviceAccount:${nebius_iam_service_account.ks-res-sa.id}"
}

resource "nebius_iam_service_account" "ks-node-sa" {
  folder_id   = var.folder_id != null ? var.folder_id : nebius_resourcemanager_folder.ks_folder[0].id
  name        = "ks-node-sa"
  description = "Service account for K8s nodes"
}

resource "nebius_resourcemanager_folder_iam_member" "ks-node-sa-editor" {
  folder_id = nebius_iam_service_account.ks-node-sa.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${nebius_iam_service_account.ks-node-sa.id}"
}

#resource "nebius_iam_service_account" "ks-ic-sa" {
#  folder_id   = var.folder_id != null ? var.folder_id : nebius_resourcemanager_folder.ks_folder[0].id
#  name        = "ks-ic-sa"
#  description = "Service account for K8s ALB ingress controler"
#}

#resource "nebius_resourcemanager_folder_iam_member" "ks-ic-sa-editor" {
#  for_each = toset([
#   "alb.editor",
#   "vpc.publicAdmin",
#   "certificate-manager.certificates.downloader",
#   "compute.viewer"
#  ])
#  folder_id = nebius_iam_service_account.ks-ic-sa.folder_id
#  role      = each.key
#  member    = "serviceAccount:${nebius_iam_service_account.ks-ic-sa.id}"
#}
