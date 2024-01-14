resource "nebius_kubernetes_cluster" "zonal_cluster" {
  name        = var.cluster_name
  description = "zonal cluster"

  folder_id  = var.folder_id != null ? var.folder_id : nebius_vpc_network.ks_network[0].folder_id
  network_id = var.network_id != null ? var.network_id : nebius_vpc_network.ks_network[0].id

  master {
    zonal {
      zone      = nebius_vpc_subnet.ks_subnet.zone
      subnet_id = nebius_vpc_subnet.ks_subnet.id
    }

    security_group_ids = [
      nebius_vpc_security_group.ks_main.id,
      nebius_vpc_security_group.ks_master_whitelist.id
    ]

    #version   = "1.27"
    public_ip = true

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        day        = "monday"
        start_time = "15:00"
        duration   = "3h"
      }

      maintenance_window {
        day        = "friday"
        start_time = "10:00"
        duration   = "4h30m"
      }
    }
  }

  service_account_id      = nebius_iam_service_account.ks-res-sa.id
  node_service_account_id = nebius_iam_service_account.ks-node-sa.id

  release_channel = "RAPID"
  #network_policy_provider = "CALICO"
}

resource "nebius_kubernetes_node_group" "worker_nodes" {
  cluster_id = nebius_kubernetes_cluster.zonal_cluster.id
  name       = "worker-nodes"
  #version    = "1.27"
  instance_template {
    platform_id = "standard-v3"
    network_interface {
      nat        = false
      subnet_ids = ["${nebius_vpc_subnet.ks_subnet.id}"]
      security_group_ids = [
        nebius_vpc_security_group.ks_main.id,
        # nebius_vpc_security_group.ks_nodes_ssh_access.id,
        nebius_vpc_security_group.ks_public_services.id
      ]
    }

    resources {
      memory = 4
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    scheduling_policy {
      preemptible = false
    }

    metadata = {
      ssh-keys = "${local.ssh_user}:${local.ssh_pubkey}"
    }
  }


  scale_policy {
    auto_scale {
      # size = 3
      min     = 1
      max     = 3
      initial = 1
    }
  }

  allocation_policy {
    location {
      zone = nebius_vpc_subnet.ks_subnet.zone
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "4h30m"
    }
  }
}
