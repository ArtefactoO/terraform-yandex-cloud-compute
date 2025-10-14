module "example_01" {
  source              = "${PATH_TO_MODULE}"
  ssh_user            = var.ssh_user
  ssh_user_public_key = var.ssh_user_public_key
  environment         = var.yc_environment

  instances = {
    example-a-01 = {
      cpu       = "4"
      memory    = "8"
      disk_size = "64"
      zone      = "${var.yc_region}-a"
      subnet_id = "${SUBNET_ID}"
    }
    example-b-02 = {
      cpu       = "4"
      memory    = "8"
      disk_size = "64"
      zone      = "${var.yc_region}-b"
      subnet_id = "${SUBNET_ID}"
    }
    example-d-03 = {
      cpu       = "4"
      memory    = "8"
      disk_size = "64"
      zone      = "${var.yc_region}-d"
      subnet_id = "${SUBNET_ID}"
    }
  }
  labels = {
    "CUSTOM_LABEL" = "VALUE"
  }
}
