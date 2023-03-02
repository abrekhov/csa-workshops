resource "yandex_vpc_gateway" "ks-nat-gateway" {
  name = "ks-nat-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "rt-ks-to-nat" {
  name       = "rt-ks-to-nat"
  network_id = var.net_id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.ks-nat-gateway.id
  }
}
