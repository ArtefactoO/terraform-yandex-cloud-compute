locals {
  instance_labels = {
    for instance_key, instance_value in var.instances : instance_key => merge(
      var.labels,
      try(instance_value.labels, {}),
      {
        "managed_by" = "terraform",
        "catalog"    = "${var.environment}"
      }
    )
  }
}

locals {
  netplan_string = {
    for name, inst in var.instances :
    name => join("\n", concat(
      [
        "network:",
        "  version: 2",
        "  ethernets:",
        "    eth0:",
        "      dhcp4: true"
      ],
      flatten([
        for nic in lookup(inst, "additional_network_interfaces", []) : [
          format("    eth%d:", nic.index),
          "      dhcp4: true",
          "      dhcp4-overrides:",
          "        use-routes: false"
        ]
      ])
    ))
  }
}

resource "yandex_compute_instance" "main" {
  for_each = var.instances

  name                      = each.key
  hostname                  = lookup(each.value, "hostname", each.key)
  platform_id               = lookup(each.value, "platform_id", var.instances_defaults.platform_id)
  zone                      = lookup(each.value, "zone", var.instances_defaults.zone)
  description               = lookup(each.value, "description", null)
  service_account_id        = try(each.value.service_account_id, null)
  allow_stopping_for_update = try(var.allow_stopping_for_update, true)

  labels = local.instance_labels[each.key]

  resources {
    cores         = lookup(each.value, "cpu", var.instances_defaults.cpu)
    core_fraction = lookup(each.value, "cpu_fraction", var.instances_defaults.cpu_fraction)
    memory        = lookup(each.value, "memory", var.instances_defaults.memory)
  }

  scheduling_policy {
    preemptible = try(each.value.preemptible, false)
  }

  boot_disk {
    auto_delete = true
    disk_id = coalesce(
      lookup(each.value, "disk_id", null),
      yandex_compute_disk.boot_disk[each.key].id
    )
  }

  dynamic "secondary_disk" {
    for_each = try(each.value.disks, {})
    content {
      disk_id     = yandex_compute_disk.secondary_disk["${each.key}-${secondary_disk.key}"].id
      auto_delete = lookup(secondary_disk.value, "auto_delete", false)
    }
  }

  network_interface {
    subnet_id          = lookup(each.value, "subnet_id", null)
    nat                = lookup(each.value, "is_public", var.instances_defaults.is_public)
    nat_ip_address     = lookup(each.value, "public_ip_address", null)
    ipv4               = lookup(each.value, "ipv4", var.instances_defaults.ipv4)
    ipv6               = lookup(each.value, "ipv6", var.instances_defaults.ipv6)
    ip_address         = lookup(each.value, "internal_ip_address", null)
    security_group_ids = lookup(each.value, "security_group_ids", var.security_group_ids)
  }

  dynamic "network_interface" {
    for_each = try(each.value.additional_network_interfaces, [])
    content {
      subnet_id  = network_interface.value.subnet_id
      nat        = network_interface.value.is_public
      ip_address = network_interface.value.internal_ip_address
      index      = network_interface.value.index
      security_group_ids = try(
        network_interface.value.security_group_ids,
        lookup(each.value, "security_group_ids", var.security_group_ids)
      )
    }
  }

  network_acceleration_type = lookup(each.value, "network_acceleration_type", var.network_acceleration_type)

  metadata = var.is_interfolder ? {
    ssh-keys           = "${var.ssh_user}:${var.ssh_user_public_key}"
    serial-port-enable = lookup(each.value, "serial_port_enable", var.instances_defaults.serial_port_enable)
    user-data = templatefile("${path.module}/templates/interfolder-cloud-init.yml", {
      ssh_user            = var.ssh_user
      ssh_user_public_key = var.ssh_user_public_key
      netplan_yaml        = local.netplan_string[each.key]
    })
    } : {
    ssh-keys           = "${var.ssh_user}:${var.ssh_user_public_key}"
    serial-port-enable = lookup(each.value, "serial_port_enable", var.instances_defaults.serial_port_enable)
    user-data = templatefile("${path.module}/templates/default-cloud-init.yml", {
      ssh_user            = var.ssh_user
      ssh_user_public_key = var.ssh_user_public_key
    })
  }
}

locals {
  boot_disks = {
    for instance_key, instance_value in var.instances : instance_key => {
      name          = lookup(instance_value, "disk_name", "${instance_key}-boot-disk")
      size          = lookup(instance_value, "disk_size", var.instances_defaults.disk_size)
      type          = lookup(instance_value, "disk_type", var.instances_defaults.disk_type)
      zone          = lookup(instance_value, "zone", var.instances_defaults.zone)
      image_id      = lookup(instance_value, "disk_image", var.instances_defaults.disk_image)
      snapshot_id   = lookup(instance_value, "snapshot_id", var.instances_defaults.snapshot_id)
      labels        = local.instance_labels[instance_key]
      auto_delete   = lookup(instance_value, "disk_auto_delete", var.instances_defaults.disk_auto_delete)
      instance_name = instance_key
    }
  }
}

resource "yandex_compute_disk" "boot_disk" {
  for_each = local.boot_disks

  name        = each.value.name
  size        = each.value.size
  type        = each.value.type
  zone        = each.value.zone
  image_id    = each.value.image_id != "" ? each.value.image_id : null
  snapshot_id = each.value.snapshot_id != "" ? each.value.snapshot_id : null

  labels = merge(
    each.value.labels,
    {
      "instance" = each.value.instance_name
    }
  )
}

locals {
  all_disks_flat = flatten([
    for instance_key, instance in var.instances : [
      for disk_key, disk in try(instance.disks, {}) : {
        key = "${instance_key}-${disk_key}",
        value = {
          name          = "${instance_key}-${disk_key}-disk",
          size          = try(disk.size, var.instances_defaults.secondary_disk_size),
          type          = try(disk.type, var.instances_defaults.secondary_disk_type),
          zone          = try(disk.zone, try(instance.zone, var.instances_defaults.zone)),
          auto_delete   = try(disk.auto_delete, false),
          snapshot_id   = try(disk.snapshot_id, ""),
          labels        = local.instance_labels[instance_key],
          instance_name = instance_key
        }
      }
    ]
  ])

  all_disks = {
    for item in local.all_disks_flat :
    item.key => {
      name          = item.value.name
      size          = item.value.size
      type          = item.value.type
      zone          = item.value.zone
      snapshot_id   = item.value.snapshot_id
      auto_delete   = item.value.auto_delete
      labels        = item.value.labels
      instance_name = item.value.instance_name
    }
  }
}

resource "yandex_compute_disk" "secondary_disk" {
  for_each = local.all_disks

  name        = each.value.name
  size        = each.value.size
  type        = each.value.type
  zone        = each.value.zone
  snapshot_id = each.value.snapshot_id

  labels = merge(
    each.value.labels,
    {
      "instance" = each.value.instance_name
    }
  )
}

locals {
  instance_name = {
    for instance_key in keys(var.instances) :
    instance_key => var.environment != null ? "${instance_key}.${var.environment}" : instance_key
  }
}

resource "yandex_dns_recordset" "dns_record" {
  for_each = var.enable_dns ? var.instances : {}

  name    = local.instance_name[each.key]
  zone_id = var.dns_zone_id
  type    = lookup(each.value, "dns_record_type", var.instances_defaults.dns_record_type)
  ttl     = lookup(each.value, "dns_record_ttl", var.instances_defaults.dns_record_ttl)

  data = [
    var.dns_nat
    ? yandex_compute_instance.main[each.key].network_interface[0].nat_ip_address
    : yandex_compute_instance.main[each.key].network_interface[0].ip_address
  ]
}
