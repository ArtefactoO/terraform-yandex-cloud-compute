output "instances_id" {
  description = "id of created instances"
  value = {
    for name, instance in yandex_compute_instance.main :
    name => instance.id
  }
}

output "instances_ip" {
  description = "ips of created instances"
  value = {
    for name, instance in yandex_compute_instance.main :
    name => instance.network_interface.0.ip_address
  }
}

output "instances_external_ips" {
  description = "external ips of created instances"
  value = {
    for name, instance in yandex_compute_instance.main :
    name => instance.network_interface.0.nat_ip_address
  }
}

output "instances_summary" {
  description = "Short summary of instances information"
  value = [
    for name, instance in yandex_compute_instance.main : {
      name         = instance.name
      dns_name     = var.environment != null && var.environment != "" ? "${name}.${var.environment}.${var.dns_domain}" : "${name}.${var.dns_domain}"
      subnet_id    = instance.network_interface[0].subnet_id
      instance_id  = instance.id
      internal_ip  = instance.network_interface[0].ip_address
      instance_cpu = instance.resources[0].cores
      instance_ram = instance.resources[0].memory
      external_ip = (
        instance.network_interface[0].nat_ip_address != null &&
        instance.network_interface[0].nat_ip_address != ""
      ) ? instance.network_interface[0].nat_ip_address : "Not assigned"
      boot_disk_size     = try(yandex_compute_disk.boot_disk[name].size, "unknown")
      boot_disk_type     = try(yandex_compute_disk.boot_disk[name].type, "unknown")
      boot_disk_image_id = try(yandex_compute_disk.boot_disk[name].image_id, "unknown")
      preemptible        = try(instance.scheduling_policy[0].preemptible, false)
      has_secondary_disk = length([
        for dk in keys(yandex_compute_disk.secondary_disk) :
        dk if startswith(dk, "${name}-")
      ]) > 0
    }
  ]
}

output "instance_interfaces" {
  value = {
    for name, inst in yandex_compute_instance.main :
    name => [
      for ni in inst.network_interface : {
        ip_address = ni.ip_address
        subnet_id  = ni.subnet_id
        zone       = inst.zone
      }
    ]
  }
}