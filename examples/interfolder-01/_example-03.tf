module "example_03" {
  source              = "${PATH_TO_MODULE}"
  ssh_user            = var.ssh_user
  ssh_user_public_key = var.ssh_user_public_key
  environment         = var.yc_environment
  security_group_ids = ["${SECURITY_GROUP_ID}"]
  is_interfolder     = true

  instances = {
    example-a-01 = {
      zone       = "ru-central1-a"
      subnet_id  = "${SUBNET_ID}"
      disk_size  = "15"
      disk_type  = "network-hdd"
      disk_image = "${IMAGE_ID}"
      internal_ip_address = "${STATIC_IP}" # Example: "10.10.2.24"
      additional_network_interfaces = [
        { // ${folder-id-1}
          subnet_id          = "${subnet-id-a1}"
          security_group_ids = ["${SECURITY_GROUP_ID}"] # ID in ${folder-id-1}
          index              = 1
          internal_ip_address= "${STATIC_IP}"
          is_public          = false
        },
        { // ${folder-id-2}
          subnet_id          = "${subnet-id-a2}"
          security_group_ids = ["${SECURITY_GROUP_ID}"] # ID in ${folder-id-2}
          index              = 2
          internal_ip_address= "${STATIC_IP}"
          is_public          = false
        },
        { // ${folder-id-3}
          subnet_id          = "${subnet-id-a3}"
          security_group_ids = ["${SECURITY_GROUP_ID}"] # ID in ${folder-id-3}
          index              = 3
          internal_ip_address= "${STATIC_IP}"
          is_public          = false
        },
      ]
    },
    example-b-02 = {
      zone       = "ru-central1-b"
      subnet_id  = "${SUBNET_ID}"
      disk_size  = "15"
      disk_type  = "network-hdd"
      disk_image = "${IMAGE_ID}"
      internal_ip_address = "${STATIC_IP}"
      additional_network_interfaces = [
        { // ${folder-id-1}
          subnet_id          = "${subnet-id-b1}"
          security_group_ids = ["${SECURITY_GROUP_ID}"]
          index              = 1
          internal_ip_address= "${STATIC_IP}"
          is_public          = false
        },
        { // ${folder-id-2}
          subnet_id          = "${subnet-id-b2}"
          security_group_ids = ["${SECURITY_GROUP_ID}"]
          index              = 2
          internal_ip_address= "${STATIC_IP}"
          is_public          = false
        },
        { // ${folder-id-3}
          subnet_id          = "${subnet-id-b3}"
          security_group_ids = ["${SECURITY_GROUP_ID}"]
          index              = 3
          internal_ip_address= "${STATIC_IP}"
          is_public          = false
        },
      ]
    },
    example-d-03 = {
      zone       = "ru-central1-d"
      subnet_id  = "${SUBNET_ID}"
      disk_size  = "15"
      disk_type  = "network-hdd"
      disk_image = "${IMAGE_ID}"
      internal_ip_address = "${STATIC_IP}"
      additional_network_interfaces = [
        { // ${folder-id-1}
          subnet_id          = "${subnet-id-d1}"
          security_group_ids = ["${SECURITY_GROUP_ID}"]
          index              = 1
          internal_ip_address= "${STATIC_IP}"
          is_public          = false
        },
        { // ${folder-id-2}
          subnet_id          = "${subnet-id-d2}"
          security_group_ids = ["${SECURITY_GROUP_ID}"]
          index              = 2
          internal_ip_address= "${STATIC_IP}"
          is_public          = false
        },
        { // ${folder-id-3}
          subnet_id          = "${subnet-id-d3}"
          security_group_ids = ["${SECURITY_GROUP_ID}"]
          index              = 3
          internal_ip_address= "${STATIC_IP}"
          is_public          = false
        }
      ]
    }
  }
}
