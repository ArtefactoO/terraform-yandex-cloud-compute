# Yandex Cloud Compute (VM) Terraform Module

A flexible Terraform module to **deploy and manage Virtual Machines (VMs)** in [Yandex Cloud], supporting simple to advanced scenarios: from a small VM group in one folder to **cross‑folder (interfolder) topologies** with multiple NICs and custom security groups.

> This README describes the repository layout, variables, examples, and outputs, and gives copy‑paste‑ready snippets.

---

## ✨ Features

- **Batch VM provisioning** — create many VMs in one run with per‑VM overrides.
- **Per‑VM resources** — set vCPU / RAM / platform / zone / labels per instance.
- **Boot & extra data disks** — size, type, auto‑delete; multiple data disks supported.
- **Multiple network interfaces** — attach NICs from different subnets/folders.
- **Security groups** — set defaults or per‑interface groups.
- **Interfolder mode** — `is_interfolder = true` to use networks/SGs from other folders.
- **DNS records (optional)** — create A/AAAA records for internal or NAT addresses.
- **Consistent metadata/labels** — unified labels for operations and automation.
- **Rich outputs** — per‑VM summary with IDs, IPs, disks, and more.

---

## 🗂 Repository Structure

```
.
├── module/main.tf                                  # Module logic
├── module/variables.tf                             # Inputs (with types, defaults, validation)
├── module/outputs.tf                               # Module outputs
├── module/versions.tf                              # Terraform/provider constraints
├── module/templates/default-cloud-init.yml         # cloud-init template (single-folder VMs)
├── module/templates/interfolder-cloud-init.yml     # cloud-init template (interfolder use)
├── examples/**/_example-01.tf                      # Example: basic VM group
├── examples/**/_example-02.tf                      # Example: additional data disks
├── examples/**/_example-03.tf                      # Example: interfolder with multiple NICs

```
> Example READMEs and usage patterns in the examples mirror this structure.  See the per‑example notes in the repo. 

---

## 🚀 Quick Start

1. **Set provider auth** (env vars or provider block).
2. **Fill `terraform.tfvars` (or use env vars)**:
   ```hcl
   yc_cloud_id    = "<cloud-id>"
   yc_folder_id   = "<folder-id>"
   yc_region      = "ru-central1"
   yc_environment = "dev"

   ssh_user            = "ubuntu"
   ssh_user_public_key = "ssh-ed25519 AAAA... user@host"
   ```
3. **Declare instances** (minimal example):
   ```hcl
   module "vm_group" {
     source               = "./"
     ssh_user             = var.ssh_user
     ssh_user_public_key  = var.ssh_user_public_key
     environment          = var.yc_environment

     instances = {
       example-a-01 = {
         zone      = "ru-central1-a"
         subnet_id = "<subnet-id-a>"
         cpu       = "2"
         memory    = "4"
         disk_size = "20"
       }
     }
   }
   ```
4. **Run**:
   ```bash
   terraform init
   terraform apply
   ```

---

## ⚙️ Inputs (Variables)

> All descriptions are concise B2‑level English. Defaults apply unless you override per instance.

### General
| Variable | Type | Default | Description |
|---|---|---:|---|
| `yc_cloud_id` | string | — | ID of the Yandex Cloud (organization) that contains the target folder. |
| `yc_folder_id` | string | — | ID of the Yandex Cloud folder where resources will be created. |
| `yc_region` | string | `"ru-central1"` | Yandex Cloud region where resources will be deployed. |
| `environment` | string\|null | `null` | Name of the Yandex Cloud folder (catalog) or environment tag for labeling. |
| `labels` | map(string)\|null | `null` | A set of custom key/value labels to attach to all resources. |

### SSH
| Variable | Type | Default | Description |
|---|---|---:|---|
| `ssh_user` | string | — | Username used for SSH access to virtual machines. |
| `ssh_user_public_key` | string | — | Public SSH key used for key-based authentication to virtual machines. |

### Network & Security
| Variable | Type | Default | Description |
|---|---|---:|---|
| `security_group_ids` | list(string) | `[]` | Default security groups for all interfaces if not overridden per instance or interface. |
| `network_acceleration_type` | string | `"standard"` | Network acceleration mode: `standard` or `software_accelerated`. |
| `is_interfolder` | bool | `false` | Specifies whether interfaces may come from different folders (interfolder setup). |

### DNS (optional)
| Variable | Type | Default | Description |
|---|---|---:|---|
| `enable_dns` | bool | `false` | If true, creates DNS records for each instance. |
| `dns_domain` | string | `""` | Domain name or prefix used when creating DNS records. |
| `dns_zone_id` | string | `""` | ID of the global DNS zone for record creation. |
| `dns_nat` | bool | `false` | If true, DNS records use NAT/public IP; if false, internal IP. |

### Instances Definition
| Variable | Type | Default | Description |
|---|---|---:|---|
| `instances` | map(any) | `{}` | A map where keys are VM names and values define per‑VM params. |
| `instances_defaults` | object | see defaults | Default values applied to all VMs unless overridden in `instances`.|

**`instances_defaults` fields (common defaults):**
- `zone` *(string)* — default availability zone, e.g., `ru-central1-a`  
- `platform_id` *(string)* — compute platform, e.g., `standard-v3`  
- `cpu` *(string)* — vCPU count (string for flexible parsing), e.g., `"2"`  
- `cpu_fraction` *(string)* — CPU performance percent, e.g., `"100"`  
- `memory` *(string)* — RAM in GB, e.g., `"4"`  
- `gpus` *(string\|null)* — optional GPU count/type  
- `disk_size` *(string)* — boot disk size in GB  
- `disk_type` *(string)* — boot disk type, e.g., `network-ssd`  
- `disk_image` *(string)* — image ID for boot disk  
- `snapshot_id` *(string\|null)* — boot disk snapshot ID (mutually exclusive with `disk_image`)  
- `is_public` *(bool)* — attach public IP to primary NIC  
- `disk_auto_delete` *(bool)* — auto delete boot disk with VM  
- `ipv4` *(bool)* — enable IPv4 on primary NIC  
- `ipv6` *(bool)* — enable IPv6 on primary NIC  
- `serial_port_enable` *(number)* — serial console enable (0/1)  
- `dns_record_type` *(string)* — `A`/`AAAA` when DNS enabled  
- `dns_record_ttl` *(string)* — TTL seconds, e.g., `"300"`  
- `secondary_disk_size` *(string)* — default extra disk size in GB  
- `secondary_disk_type` *(string)* — default extra disk type

**Per‑instance overrides** may include:
- Compute: `zone`, `platform_id`, `cpu`, `cpu_fraction`, `memory`, `gpus`
- Boot disk: `disk_size`, `disk_type`, `disk_image` **or** `snapshot_id`
- Network: `subnet_id`, `internal_ip_address`, `is_public`, `ipv4`, `ipv6`, `security_group_ids`
- Extra disks: `data_disks = [{ name, size, type }, … ]` (if supported in your module version)
- Multiple NICs: `additional_network_interfaces = [{ subnet_id, internal_ip_address, index, is_public, security_group_ids? }, … ]`
- Labels/metadata: `labels`, custom metadata

> **Tips**
> - IPs must belong to the **CIDR** of the selected subnet.  
> - `index` for additional NICs must be unique per instance (1,2,3 …).  
> - For interfolder, make sure referenced subnets/SGs are accessible from the target folder/project.

---

## 🔌 Interfolder (Cross‑Folder) Networks

Pass a helper structure like `connected_folders` in your root config to document or compute which subnets/SGs correspond to which zones. Example `terraform.tfvars` excerpt:

```hcl
connected_folders = [
  {
    folder_id = "<folder-id-1>"
    connected_networks = [
      { zone = "${yc_region}-a", subnet_id = "<subnet-id-a1>", prefix = "10.10.10.0/24" },
      { zone = "${yc_region}-b", subnet_id = "<subnet-id-b1>", prefix = "10.10.11.0/24" },
      { zone = "${yc_region}-d", subnet_id = "<subnet-id-d1>", prefix = "10.10.12.0/24" }
    ]
  }
]
```
> `prefix` is a **CIDR** (e.g., `10.10.10.0/24`). Use unique IPs per NIC that fall into their CIDRs.

---

## 📦 Examples

- **Basic group** — three VMs in different zones within one folder.  
- **With extra data disks** — attach multiple additional disks per VM.  
- **Interfolder with multiple NICs** — NICs from subnets and folders different from the VM’s folder.

Each example includes a minimal `main.tf`, per‑VM overrides, and a small `_outputs.tf` to print a summary.

---

## 📤 Outputs

Typical outputs include a **summary map by instance name**, with fields like:
- VM ID, Name, Zone
- Internal and external IPs
- Boot & data disks info
- DNS records (if enabled)

Consume them from your root as:
```hcl
output "instances_summary" {
  value = module.vm_group.instances_summary
}
```

---

## ✅ Requirements

- Terraform `>= 1.5.7`
- Provider `yandex-cloud/yandex >= 0.100`
- IAM permissions to create compute/network/DNS resources

---

## 🧰 Troubleshooting & Gotchas

- **IPs outside subnet** → ensure `internal_ip_address` ∈ `prefix` (CIDR).  
- **Duplicate NIC index** → `index` must be unique per VM.  
- **Wrong zone/subnet pair** → subnet’s zone must match VM zone.  
- **Interfolder SGs** → use SG IDs from the *same* folder as the interface.  
- **`disk_image` vs `snapshot_id`** → use only one for the boot disk.
- **Multiple data disks order** — when attaching multiple additional data disks, their attachment order is **not guaranteed** (it may be random). Do not rely on device indices/names (e.g., `/dev/vdb`, `/dev/vdc`); instead use disk labels/names, filesystem UUIDs, or udev rules.  
  **Workaround:** if you must control the attachment sequence, create disks in **separate Terraform applies** (e.g., add disk #1 → `apply`, then add disk #1 + #2 → `apply`, then disk #1 + #2 + #3 → `apply`). This enforces the order by creation steps.

---

## 🤝 Contributing

Issues and PRs are welcome: typo fixes, features, validations, docs, examples.
