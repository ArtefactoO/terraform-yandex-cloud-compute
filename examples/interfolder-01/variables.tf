variable "yc_folder_id" {
  description = "ID of the Yandex Cloud folder where all resources will be created."
}

variable "yc_cloud_id" {
  description = "ID of the Yandex Cloud organization (cloud) that contains the target folder."
}

variable "yc_environment" {
  description = "Name of the deployment environment (for example: dev, stage, prod)."
}

variable "yc_region" {
  description = "Yandex Cloud region where resources will be deployed."
  default     = "ru-central1"
}

variable "ssh_user" {
  description = "Username used for SSH access to virtual machines."
}

variable "ssh_user_public_key" {
  description = "Public SSH key used for key-based authentication to virtual machines."
}

variable "additional_network_interfaces" {
  description = "Additional network interfaces for instances."
  type = map(list(object({
    subnet_id           = string
    internal_ip_address = string
    index               = number
    is_public           = bool
  })))
  default = {}
}