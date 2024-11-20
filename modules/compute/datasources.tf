data "oci_core_images" "compute_images" {
    #Required
    compartment_id = "${var.compartment_ocid}"

    #Optional
    operating_system = "Oracle Linux"
    operating_system_version = "8"
    
    filter {
      name   = "display_name"
      values = ["Oracle-Linux-8.10-2024.09.30-0"]
    }

    filter {
      name   = "state"
      values = ["AVAILABLE"]
    }
}

data "local_file" "cloud_init" {
  filename = "${path.module}/cloud-init-scripts/cloud-init.yaml"
}
