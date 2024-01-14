locals {
  api_endpoint     = var.api_endpoint != null ? var.api_endpoint : "api.il.nebius.cloud:443"
  storage_endpoint = var.storage_endpoint != null ? var.storage_endpoint : "storage.il.nebius.cloud:443"

  cloud_zone = var.cloud_zone != null ? var.cloud_zone : "il1-b"

  ssh_user   = var.ssh_user != null ? var.ssh_user : "ncp-user"
  ssh_pubkey = var.ssh_pubkey != null ? var.ssh_pubkey : "${file("~/.ssh/id_rsa.pub")}" # "${file("~/.ssh/id_ed25519.pub")}"
}
