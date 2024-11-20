# Variables passed into compute module

variable "compartment_ocid" {}
variable "availability_domain" {}
variable "public_subnet_ocid" {}
variable "instance_shape" {}
variable "name_prefix" {}
variable "wallet_content" {}
variable "freeform_tags" {
  default = {
    "Owner" = "ADB"
  }
}
variable "num_nodes" {
    default = 1
}
variable "ssh_private_key" {
    default = "/home/user/.ssh/id_rsa"
}

variable "compute_nsg_id" {}
variable "source_id" {
  default = "ocid1.image.oc1.ap-seoul-1.aaaaaaaaxzlqiuwv6j2r7n3mh4glcqot4ckuneg6g54qvugd3daqr4qjxqvq"
}