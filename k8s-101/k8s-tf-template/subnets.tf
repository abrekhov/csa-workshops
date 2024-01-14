resource "nebius_vpc_subnet" "ks_subnet" {
  folder_id = var.folder_id != null ? var.folder_id : nebius_vpc_network.ks_network[0].folder_id

  name           = "${var.cluster_name}-subnet"
  v4_cidr_blocks = ["10.138.1.0/24"]
  zone           = local.cloud_zone
  network_id     = var.network_id != null ? var.network_id : nebius_vpc_network.ks_network[0].id
  route_table_id = nebius_vpc_route_table.rt-ks-to-nat.id
}
