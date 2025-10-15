module "example_02" {
  source              = "<PATH_TO_MODULE>"
  ssh_user            = var.ssh_user
  ssh_user_public_key = var.ssh_user_public_key
  environment         = var.yc_environment
  security_group_ids  = ["<SECURITY_GROUP_ID>"] 

  instances = {
    example-a-01 = {
      cpu        = "24"
      memory     = "24"
      disk_image = "<IMAGE_ID>" 
      disk_size  = "93"
      disk_type  = "network-ssd"
      disks = {
        data = {
          size = "558"
          type = "network-ssd"
        }
        journal = {
          size = "93"
          type = "network-ssd-io-m3"
        }
      }
      zone      = "${var.yc_region}-a"
      subnet_id = "<SUBNET_ID>"
    }
    example-b-02 = {
      cpu        = "24"
      memory     = "24"
      disk_image = "<IMAGE_ID>"
      disk_size  = "93"
      disk_type  = "network-ssd"
      disks = {
        data = {
          size = "558"
          type = "network-ssd"
        }
        journal = {
          size = "93"
          type = "network-ssd-io-m3"
        }
      }
      zone      = "${var.yc_region}-b"
      subnet_id = "<SUBNET_ID>"
    }
    example-d-03 = {
      cpu        = "24"
      memory     = "24"
      disk_image = "<IMAGE_ID>"
      disk_size  = "93"
      disk_type  = "network-ssd"
      disks = {
        data = {
          size = "558"
          type = "network-ssd"
        }
        journal = {
          size = "93"
          type = "network-ssd-io-m3"
        }
      }
      zone      = "${var.yc_region}-d"
      subnet_id = "<SUBNET_ID>"
    }
  }
  labels = {
    "CUSTOM_LABEL" = "VALUE"
  }
}
