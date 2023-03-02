resource "yandex_kubernetes_cluster" "zonal_cluster" {
  name        = var.cluster_name
  description = "zonal cluster"

  network_id = var.net_id

  master {
    zonal {
      zone      = yandex_vpc_subnet.ksnet_a.zone
      subnet_id = yandex_vpc_subnet.ksnet_a.id
    }

    security_group_ids = [
      yandex_vpc_security_group.ks_main.id,
      yandex_vpc_security_group.ks_master_whitelist.id
    ]

    version   = "1.23"
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

  service_account_id      = yandex_iam_service_account.kssa.id
  node_service_account_id = yandex_iam_service_account.kssa.id

  release_channel         = "RAPID"
  network_policy_provider = "CALICO"
}

resource "yandex_kubernetes_node_group" "worker_nodes" {
  cluster_id = yandex_kubernetes_cluster.zonal_cluster.id
  name       = "worker-nodes"
  version    = "1.23"
  instance_template {
    platform_id = "standard-v3"
    network_interface {
      nat        = false
      subnet_ids = ["${yandex_vpc_subnet.ksnet_a.id}"]
      security_group_ids = [
        yandex_vpc_security_group.ks_main.id,
        # yandex_vpc_security_group.ks_nodes_ssh_access.id,
        yandex_vpc_security_group.ks_public_services.id
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
      ssh-keys = "abrekhov:${file("~/.ssh/id_ed25519.pub")}"
    }
  }


  scale_policy {
    auto_scale {
      # size = 3
      min     = 3
      max     = 5
      initial = 3
    }
  }

  allocation_policy {
    location {
      zone = yandex_vpc_subnet.ksnet_a.zone
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
