# Example: Cross-Folder Usage with `compute_cloud/module` (interfolder-01)

This example demonstrates how to create virtual machines (VMs) in Yandex Cloud using the [`compute_cloud/module`](../../module) with **cross-folder network interfaces** enabled.

## What Is Created

- **Three VMs**: `example-a-01`, `example-b-02`, `example-d-03`
- Each VM is created in a specific zone (`ru-central1-a`, `ru-central1-b`, `ru-central1-d`)
- Each VM:
  - Uses a dedicated subnet (`subnet_id`)
  - Has main disk (`disk_size`, `disk_type`, `disk_image`)
  - Gets a static internal IP address (`internal_ip_address`)
  - Has additional network interfaces (3 per each VM), each linked to a subnet from a **different folder** (illustrated as `${folder-id-1}`, `${folder-id-2}`, `${folder-id-3}`):
    - Every network interface is assigned a specific subnet
    - Each can have its own security group IDs and internal IP
    - All network interfaces are private (no public IP by default)
- SSH access is set up for each VM with `ssh_user` and `ssh_user_public_key`
- You can specify a security group for the root network interface as well

## Important Module Parameter

- `is_interfolder = true` — This activates logic inside the module to create and attach resources from **multiple folders**. Required when referencing networks, subnets, or security groups from folders different than where the VMs are created.

## Files in This Example

- `_example-03.tf` — main example: source code to create all resources and attach multiple NICs from multiple folders
- `variables.tf` — defines all needed variables (user, keys, image, subnet IDs, etc.)
- `terraform.tfvars` — example variable values (should be updated with your real values)
- `_outputs.tf` — shows summary information after applying

## Outputs

After applying the configuration, you will get in outputs:
- The IDs, internal IPs, zones, and NIC details for all created VMs


## Terraform states examples

```
module.example_03.yandex_compute_disk.boot_disk["example-a-01"]
module.example_03.yandex_compute_disk.boot_disk["example-b-02"]
module.example_03.yandex_compute_disk.boot_disk["example-d-03"]
module.example_03.yandex_compute_instance.main["example-a-01"]
module.example_03.yandex_compute_instance.main["example-b-02"]
module.example_03.yandex_compute_instance.main["example-d-03"]
```

## How to Use

1. Fill in all variable values in `terraform.tfvars`, especially:
    - Subnet IDs across all target folders
    - Security group IDs (if any)
    - Static IPs for each interface
2. Set `is_interfolder = true`
3. Run:
    ```sh
    terraform init
    terraform apply
    ```

---

For more details about all configuration options for cross-folder deployments, refer to the [compute_cloud/module documentation](../../module).