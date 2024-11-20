# Output variables from created compartment

output "adb_database" {
  value = {
    adb_database_id    = oci_database_autonomous_database.adb_database.id
    connection_urls    = oci_database_autonomous_database.adb_database.connection_urls
    adb_wallet_content = oci_database_autonomous_database_wallet.adb_database_wallet.content
    # adb_nsg_id         = (!var.use_existing_vcn && var.adb_private_endpoint) ? oci_core_network_security_group.adb_nsg[0].id : var.adb_nsg_id
  }
}

output "compute_public_subnet_ocid" {
  value = oci_core_subnet.compute_public_subnet[0].id
}

output "compute_nsg_id" {
  value = oci_core_network_security_group.compute_nsg[0].id
}