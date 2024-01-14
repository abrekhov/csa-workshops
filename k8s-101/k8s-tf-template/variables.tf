variable "api_endpoint" {
  type    = string
  default = null
}
variable "storage_endpoint" {
  type    = string
  default = null
}
variable "cloud_zone" {
  type    = string
  default = null
}

variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type    = string
  default = null
}

variable "network_id" {
  type    = string
  default = null
}

variable "ssh_user" {
  type    = string
  default = null
}
variable "ssh_pubkey" {
  type    = string
  default = null
}

variable "cluster_name" {
  type    = string
  default = "kube-lab"
}

