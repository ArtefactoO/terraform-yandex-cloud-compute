This example shows how to deploy a group of virtual machines (VMs) in Yandex Cloud using the [`compute_cloud/module`](../../module). It demonstrates a common scenario for building a compute cloud environment.

## Resources Created

- The module creates **3 virtual machines**:
  - `example-a-01` — located in `${yc_region}-a`
  - `example-b-02` — located in `${yc_region}-b`
  - `example-d-03` — located in `${yc_region}-d`
- For each VM:
  - vCPU count: **24**
  - RAM: **24 GB**
  - Disk: **93 GB** (type: SSD or as defined in the module)
  - Additional data disks:
    - `data` disk: 558 GB, `network-ssd-io-m3`
    - `journal` disk: 93 GB, `network-ssd-io-m3`
  - VM is placed in the given subnet (`subnet_id`)
  - SSH access with your username and public key (`ssh_user`, `ssh_user_public_key`)
  - Custom labels (for example: `"CUSTOM_LABEL" = "VALUE"`)
- You can assign network security groups with `security_group_ids`
- All parameters like CPU, RAM, zone, disk sizes, and types can be adjusted through the `instances` block
- The cloud and folder are selected by module variables (`yc_cloud_id`, `yc_folder_id`)
- The VM names match the keys in the `instances` block

## Files and Variables

- `main.tf`: provider settings and backend initialization
- `_example-02.tf`: describes instances and passes their parameters to the module
- `variables.tf`: defines all variables (Cloud ID, Folder ID, SSH user, region, etc.)
- `terraform.tfvars`: place your actual variable values here (do not commit sensitive data)
- `_outputs.tf`: exports output information about the created VMs

## Outputs

The file `_outputs.tf` shows a summary for each created VM using the module's `instances_summary` output:
- Name, DNS, VM ID
- Internal and external IP addresses
- Hardware specification, disks, and more

## How to Use

1. Set correct values for all variables (in `terraform.tfvars` or as environment variables)
2. Update the correct value for `subnet_id` and names if needed
3. Run:
    ```sh
    terraform init
    terraform apply
    ```

---

For all available options and a full description of parameters, see the documentation for [compute_cloud/module](../../module).