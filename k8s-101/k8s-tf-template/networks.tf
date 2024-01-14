resource "nebius_vpc_network" "ks_network" {
  count     = var.network_id == null ? 1 : 0
  folder_id = var.folder_id != null ? var.folder_id : nebius_resourcemanager_folder.ks_folder[0].id
  name      = "${var.cluster_name}-network"
}
