data "oci_core_services" "AllOCIServices" {
  count = (!var.use_existing_vcn && var.adb_private_endpoint) ? 1 : 0
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

data "oci_database_autonomous_database" "adb_database" {
  autonomous_database_id = oci_database_autonomous_database.adb_database.id
}