resource "nebius_vpc_gateway" "ks-nat-gateway" {
  folder_id = var.folder_id != null ? var.folder_id : nebius_resourcemanager_folder.ks_folder[0].id
  name      = "${var.cluster_name}-nat-gateway"

  shared_egress_gateway {}
}

resource "nebius_vpc_route_table" "rt-ks-to-nat" {
  name       = "rt-ks-to-nat"
  folder_id  = nebius_vpc_gateway.ks-nat-gateway.folder_id
  network_id = var.network_id != null ? var.network_id : nebius_vpc_network.ks_network[0].id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = nebius_vpc_gateway.ks-nat-gateway.id
  }
}
