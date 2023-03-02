resource "yandex_vpc_subnet" "ksnet_a" {
  name           = "${var.cluster_name}-subnet-a"
  v4_cidr_blocks = ["10.138.1.0/24"]
  zone           = "il1-a"
  network_id     = var.net_id
  route_table_id = yandex_vpc_route_table.rt-ks-to-nat.id
}

# resource "yandex_vpc_subnet" "ksnet_b" {
#   name           = "${var.cluster_name}-subnet-b"
#   v4_cidr_blocks = ["10.138.2.0/24"]
#   zone           = "il1-b"
#   network_id     = var.net_id
# }

# resource "yandex_vpc_subnet" "ksnet_c" {
#   name           = "${var.cluster_name}-subnet-c"
#   v4_cidr_blocks = ["10.138.3.0/24"]
#   zone           = "il1-c"
#   network_id     = var.net_id
# }
