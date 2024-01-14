resource "nebius_vpc_security_group" "ks_main" {
  name        = "ks-sg"
  description = "description for my security group"
  network_id  = var.network_id != null ? var.network_id : nebius_vpc_network.ks_network[0].id
  folder_id   = var.folder_id != null ? var.folder_id : nebius_vpc_network.ks_network[0].folder_id

#  ingress {
#    protocol       = "TCP"
#    description    = "Rule allows availability checks from load balancer's address range. It is required for the operation of a fault-tolerant cluster and load balancer services."
#    v4_cidr_blocks = ["198.18.235.0/24", "198.18.248.0/24"]
#    from_port      = 0
#    to_port        = 65535
#  }

  ingress {
    protocol          = "ANY"
    description       = "Rule allows availability checks from load balancer's address range. It is required for the operation of a fault-tolerant cluster and load balancer services."
    predefined_target = "loadbalancer_healthchecks"
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol          = "ANY"
    description       = "Rule allows master-node and node-node communication inside a security group."
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol       = "ANY"
    description    = "Pod-pod and service service commx"
    v4_cidr_blocks = nebius_vpc_subnet.ks_subnet.v4_cidr_blocks
    from_port      = 0
    to_port        = 65535
  }

  ingress {
    protocol       = "ICMP"
    description    = "Internetwork debug pings"
    # FIXME: Where is defined 172.16/12?
    v4_cidr_blocks = ["172.16.0.0/12"] # , "10.0.0.0/8", "192.168.0.0/16"
  }

  egress {
    protocol       = "ANY"
    description    = "External traffic anywhere"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}


resource "nebius_vpc_security_group" "ks_public_services" {
  name        = "k8s-public-services"
  description = "Allow for services etc. Allow only for node_group."
  network_id  = var.network_id != null ? var.network_id : nebius_vpc_network.ks_network[0].id
  folder_id   = var.folder_id != null ? var.folder_id : nebius_vpc_network.ks_network[0].folder_id

  ingress {
    protocol       = "TCP"
    description    = "Ingress traffic on range of NodePort"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 30000
    to_port        = 32767
  }
}

# resource "nebius_vpc_security_group" "ks_nodes_ssh_access" {
#   name        = "k8s-nodes-ssh-access"
#   description = "Allow ssh on nodegroup"
# network_id = var.network_id != null ? var.network_id : nebius_vpc_network.ks_network[0].id

#   ingress {
#     protocol       = "TCP"
#     description    = "Allow ssh on nodegroup"
#     v4_cidr_blocks = ["5.255.221.9/32"]
#     port           = 22
#   }
# }

resource "nebius_vpc_security_group" "ks_master_whitelist" {
  name        = "k8s-master-whitelist"
  description = "Allow API for ks master"
  network_id  = var.network_id != null ? var.network_id : nebius_vpc_network.ks_network[0].id
  folder_id   = var.folder_id != null ? var.folder_id : nebius_vpc_network.ks_network[0].folder_id

  ingress {
    protocol       = "TCP"
    description    = "Allow API for ks master"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 6443
  }

  ingress {
    protocol       = "TCP"
    description    = "Allow API for ks master"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  ingress {
    protocol          = "TCP"
    description       = "Allow TCP from workers"
    security_group_id = nebius_vpc_security_group.ks_main.id
    from_port         = 0
    to_port           = 65535
  }
}
