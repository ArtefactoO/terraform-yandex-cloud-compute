variable "environment" {
  description = "Yandex Cloud catalog"
  default     = null
}

variable "instances" {
  description = "Map for instances."
  type        = map(any)
  default     = {}
}

variable "instances_defaults" {
  description = "Map of common default values for instances."
  type = object({
    zone                = string
    platform_id         = string
    cpu                 = string
    cpu_fraction        = string
    memory              = string
    gpus                = string
    disk_size           = string
    disk_type           = string
    disk_image          = string
    snapshot_id         = string
    is_public           = bool
    disk_auto_delete    = bool
    ipv4                = bool
    ipv6                = bool
    serial_port_enable  = number
    dns_record_type     = string
    dns_record_ttl      = string
    secondary_disk_size = string
    secondary_disk_type = string
  })

  default = {
    zone                = "ru-central1-a"
    platform_id         = "standard-v3"
    cpu                 = "2"
    cpu_fraction        = "100"
    memory              = "4"
    gpus                = null
    disk_size           = "20"
    disk_type           = "network-ssd"
    disk_image          = "fd8nru7hnggqhs9mkqps"
    snapshot_id         = null
    is_public           = false
    disk_auto_delete    = true
    ipv4                = true
    ipv6                = false
    serial_port_enable  = 0
    dns_record_type     = "A"
    dns_record_ttl      = "300"
    secondary_disk_size = "64"
    secondary_disk_type = "network-ssd"
  }
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

variable "network_acceleration_type" {
  description = "Network acceleration type for instances."
  type        = string
  default     = "standard"
  validation {
    condition     = contains(["standard", "software_accelerated"], var.network_acceleration_type)
    error_message = "Type of network acceleration. Available values: standard, software_accelerated."
  }
}

variable "allow_stopping_for_update" {
  description = "If true, Terraform is allowed to stop the virtual machine when applying updates that require a restart (for example, changes to CPU, memory, or disk configuration)"
  type        = string
  default     = true
}

variable "labels" {
  description = "Set of key/value label."
  type        = map(string)
  default     = null
}

variable "ssh_user" {
  description = "The username for SSH authentication."
}

variable "ssh_user_public_key" {
  description = "The public key for the SSH user for key-based authentication."
}

variable "yc_folder_name" {
  description = "Yandex Cloud catalog"
  default     = null
}

variable "enable_dns" {
  description = "Create dns records"
  type        = bool
  default     = false
}

variable "dns_domain" {
  description = "Domain prefix"
  default     = ""
}

variable "dns_zone_id" {
  description = "Global DNS Zone ID"
  type        = string
  default     = ""
}

variable "dns_nat" {
  description = "Use NAT IP address for DNS if true, otherwise use network interface IP address."
  type        = bool
  default     = false
}

variable "is_interfolder" {
  description = "Is compute cloud an interfolder"
  type        = bool
  default     = false
}

variable "security_group_ids" {
  description = "Default security groups for all interfaces if not overridden per instance or per interface"
  type        = list(string)
  default     = []
}
