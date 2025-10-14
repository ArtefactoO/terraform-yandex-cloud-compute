<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | >= 0.100 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | >= 0.100 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [yandex_compute_disk.boot_disk](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_disk) | resource |
| [yandex_compute_disk.secondary_disk](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_disk) | resource |
| [yandex_compute_instance.main](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance) | resource |
| [yandex_dns_recordset.dns_record](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/dns_recordset) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_network_interfaces"></a> [additional\_network\_interfaces](#input\_additional\_network\_interfaces) | Additional network interfaces for instances. | <pre>map(list(object({<br>    subnet_id           = string<br>    internal_ip_address = string<br>    index               = number<br>    is_public           = bool<br>  })))</pre> | `{}` | no |
| <a name="input_dns_domain"></a> [dns\_domain](#input\_dns\_domain) | Yandex Cloud catalog | `string` | `"urent.tech"` | no |
| <a name="input_dns_nat"></a> [dns\_nat](#input\_dns\_nat) | Use NAT IP address for DNS if true, otherwise use network interface IP address. | `bool` | `false` | no |
| <a name="input_dns_zone_id"></a> [dns\_zone\_id](#input\_dns\_zone\_id) | Global DNS Zone ID | `string` | `"dns5obga0t3150tv2poj"` | no |
| <a name="input_enable_dns"></a> [enable\_dns](#input\_enable\_dns) | n/a | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Yandex Cloud catalog | `any` | `null` | no |
| <a name="input_instances"></a> [instances](#input\_instances) | Map for instances. | `map(any)` | `{}` | no |
| <a name="input_instances_defaults"></a> [instances\_defaults](#input\_instances\_defaults) | Map of common default values for instances. | <pre>object({<br>    zone                = string<br>    platform_id         = string<br>    cpu                 = string<br>    cpu_fraction        = string<br>    memory              = string<br>    gpus                = string<br>    disk_size           = string<br>    disk_type           = string<br>    disk_image          = string<br>    snapshot_id         = string<br>    is_public           = bool<br>    disk_auto_delete    = bool<br>    ipv4                = bool<br>    ipv6                = bool<br>    serial_port_enable  = number<br>    dns_record_type     = string<br>    dns_record_ttl      = string<br>    secondary_disk_size = string<br>    secondary_disk_type = string<br>  })</pre> | <pre>{<br>  "cpu": "2",<br>  "cpu_fraction": "100",<br>  "disk_auto_delete": true,<br>  "disk_image": "fd8nru7hnggqhs9mkqps",<br>  "disk_size": "20",<br>  "disk_type": "network-ssd",<br>  "dns_record_ttl": "300",<br>  "dns_record_type": "A",<br>  "gpus": null,<br>  "ipv4": true,<br>  "ipv6": false,<br>  "is_public": false,<br>  "memory": "4",<br>  "platform_id": "standard-v3",<br>  "secondary_disk_size": "64",<br>  "secondary_disk_type": "network-ssd",<br>  "serial_port_enable": 0,<br>  "snapshot_id": null,<br>  "zone": "ru-central1-a"<br>}</pre> | no |
| <a name="input_is_interfolder"></a> [is\_interfolder](#input\_is\_interfolder) | Is compute cloud an interfolder | `bool` | `false` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Set of key/value label. | `map(string)` | `null` | no |
| <a name="input_network_acceleration_type"></a> [network\_acceleration\_type](#input\_network\_acceleration\_type) | Network acceleration type for instances. | `string` | `"standard"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Default security groups for all interfaces if not overridden per instance or per interface | `list(string)` | `[]` | no |
| <a name="input_ssh_user"></a> [ssh\_user](#input\_ssh\_user) | The username for SSH authentication. | `any` | n/a | yes |
| <a name="input_ssh_user_public_key"></a> [ssh\_user\_public\_key](#input\_ssh\_user\_public\_key) | The public key for the SSH user for key-based authentication. | `any` | n/a | yes |
| <a name="input_yc_folder_name"></a> [yc\_folder\_name](#input\_yc\_folder\_name) | Yandex Cloud catalog | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_interfaces"></a> [instance\_interfaces](#output\_instance\_interfaces) | n/a |
| <a name="output_instances_external_ips"></a> [instances\_external\_ips](#output\_instances\_external\_ips) | external ips of created instances |
| <a name="output_instances_id"></a> [instances\_id](#output\_instances\_id) | id of created instances |
| <a name="output_instances_ip"></a> [instances\_ip](#output\_instances\_ip) | ips of created instances |
| <a name="output_instances_summary"></a> [instances\_summary](#output\_instances\_summary) | Short summary of instances information |
<!-- END_TF_DOCS -->