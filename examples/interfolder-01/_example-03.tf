module "example_03" {
  source              = "<PATH_TO_MODULE>" 
  ssh_user            = var.ssh_user
  ssh_user_public_key = var.ssh_user_public_key
  environment         = var.yc_environment
  security_group_ids = ["<SECURITY_GROUP_ID>"] 
  is_interfolder     = true

  instances = {
    example-a-01 = {
      zone       = "${var.yc_region}-a"
      subnet_id  = "<SUBNET_ID>"
      disk_size  = "15"
      disk_type  = "network-hdd"
      disk_image = "<IMAGE_ID>"
      internal_ip_address = "<STATIC_IP>" # Example: "10.10.2.24"
      additional_network_interfaces = [
        { // <FOLDER-ID-1>
          subnet_id          = "<SUBNET-ID-a1}>"
          security_group_ids = ["<SECURITY_GROUP_ID>"]  # ID in <FOLDER-ID-1>
          index              = 1
          internal_ip_address= "<STATIC_IP>"
          is_public          = false
        },
        { // <FOLDER-ID-2>
          subnet_id          = "<SUBNET-ID-a2>"
          security_group_ids = ["<SECURITY_GROUP_ID>"]  # ID in <FOLDER-ID-2>
          index              = 2
          internal_ip_address= "<STATIC_IP>"
          is_public          = false
        },
        { // <FOLDER-ID-3>
          subnet_id          = "<SUBNET-ID-a3>"
          security_group_ids = ["<SECURITY_GROUP_ID>"]  # ID in <FOLDER-ID-3>
          index              = 3
          internal_ip_address= "<STATIC_IP>"
          is_public          = false
        },
      ]
    },
    example-b-02 = {
      zone       = "${var.yc_region}-b"
      subnet_id  = "<SUBNET_ID>"
      disk_size  = "15"
      disk_type  = "network-hdd"
      disk_image = "<IMAGE_ID>"
      internal_ip_address = "<STATIC_IP>"
      additional_network_interfaces = [
        { // <FOLDER-ID-1>
          subnet_id          = "<SUBNET-ID-b1>"
          security_group_ids = ["<SECURITY_GROUP_ID>"] 
          index              = 1
          internal_ip_address= "<STATIC_IP>"
          is_public          = false
        },
        { // <FOLDER-ID-2>
          subnet_id          = "$<SUBNET-ID-b2>"
          security_group_ids = ["<SECURITY_GROUP_ID>"] 
          index              = 2
          internal_ip_address= "<STATIC_IP>"
          is_public          = false
        },
        { // <FOLDER-ID-3>
          subnet_id          = "<SUBNET-ID-b3>"
          security_group_ids = ["<SECURITY_GROUP_ID>"] 
          index              = 3
          internal_ip_address= "<STATIC_IP>"
          is_public          = false
        },
      ]
    },
    example-d-03 = {
      zone       = "${var.yc_region}-d"
      subnet_id  = "<SUBNET_ID>"
      disk_size  = "15"
      disk_type  = "network-hdd"
      disk_image = "<IMAGE_ID>"
      internal_ip_address = "<STATIC_IP>"
      additional_network_interfaces = [
        { // <FOLDER-ID-1>
          subnet_id          = "<SUBNET-ID-d1>"
          security_group_ids = ["<SECURITY_GROUP_ID>"] 
          index              = 1
          internal_ip_address= "<STATIC_IP>"
          is_public          = false
        },
        { // <FOLDER-ID-2>
          subnet_id          = "<SUBNET-ID-d2>"
          security_group_ids = ["<SECURITY_GROUP_ID>"] 
          index              = 2
          internal_ip_address= "<STATIC_IP>"
          is_public          = false
        },
        { // <FOLDER-ID-3>
          subnet_id          = "<SUBNET-ID-d3>"
          security_group_ids = ["<SECURITY_GROUP_ID>"] 
          index              = 3
          internal_ip_address= "<STATIC_IP>"
          is_public          = false
        }
      ]
    }
  }
}
