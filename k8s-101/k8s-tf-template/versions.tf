terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">=0.69.0"
    }
  }
}

provider "yandex" {
  endpoint = "api.cloudil.com:443"
}
