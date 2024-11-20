## Copyright © 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_core_vcn" "adb_vcn" {
  count          = 1
  cidr_block     = var.vcn_cidr
  compartment_id = var.compartment_ocid
  display_name   = "adb_vcn"
  dns_label      = "adbvcn"
  defined_tags   = var.defined_tags
}

resource "oci_core_internet_gateway" "compute_igw" {
  count          = 1
  compartment_id = var.compartment_ocid
  display_name   = "compute_igw"
  vcn_id         = oci_core_vcn.adb_vcn[0].id
  defined_tags   = var.defined_tags
}


resource "oci_core_route_table" "compute_rt_via_igw" {
  count          = 1
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.adb_vcn[0].id
  display_name   = "compute_rt_via_igw"
  defined_tags   = var.defined_tags

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.compute_igw[0].id
  }
}

resource "oci_core_network_security_group" "compute_nsg" {
  count          = 1
  compartment_id = var.compartment_ocid
  display_name   = "compute_nsg"
  vcn_id         = oci_core_vcn.adb_vcn[0].id
  defined_tags   = var.defined_tags
}

resource "oci_core_network_security_group_security_rule" "compute_nsg_egress_group_sec_rule" {
  count                     = 1
  network_security_group_id = oci_core_network_security_group.compute_nsg[0].id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
}

resource "oci_core_network_security_group_security_rule" "compute_nsg_ingress_group_sec_rule" {
  count                     = 2
  network_security_group_id = oci_core_network_security_group.compute_nsg[0].id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      max = count.index == 0 ? 3000 : 8080
      min = count.index == 0 ? 3000 : 8080
    }
  }
}

resource "oci_core_subnet" "compute_public_subnet" {
  count                      = 1
  cidr_block                 = var.compute_subnet_cidr
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_vcn.adb_vcn[0].id
  display_name               = "compute_public_subnet"
  dns_label                  = "computenet"
  security_list_ids          = [oci_core_vcn.adb_vcn[0].default_security_list_id]
  route_table_id             = oci_core_route_table.compute_rt_via_igw[0].id
  prohibit_public_ip_on_vnic = false
  defined_tags               = var.defined_tags
}