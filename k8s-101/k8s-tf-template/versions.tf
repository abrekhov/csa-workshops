terraform {
  required_providers {
    nebius = {
      source  = "terraform-registry.storage.ai.nebius.cloud/nebius/nebius"
      version = ">= 0.6.0" # Optional
    }
  }
  required_version = ">= 0.13"
}

provider "nebius" {
  zone     = local.cloud_zone
  endpoint = local.api_endpoint
  #  storage_endpoint = local.storage_endpoint
}
