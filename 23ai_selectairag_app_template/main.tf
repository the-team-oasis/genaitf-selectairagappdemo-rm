module "adb" {
  source                                = "../modules/adb"
  adb_database_db_name                  = "myatp"
  adb_database_display_name             = "myatp"
  adb_password                          = var.adb_password
  adb_database_db_workload              = "OLTP" # Autonomous Transaction Processing (ATP)
  adb_free_tier                         = false
  compute_count                         = var.compute_count
  compute_model                         = "ECPU"
  adb_database_data_storage_size_in_tbs = 1
  compartment_ocid                      = var.compartment_ocid
  # use_existing_vcn                      = false
  # adb_private_endpoint                  = true
  # adb_private_endpoint_label            = "myatppe"
}

module "compute" {
  source                                = "../modules/compute"
  availability_domain                   = var.availability_domain
  compartment_ocid                      = var.compartment_ocid
  public_subnet_ocid                    = module.adb.compute_public_subnet_ocid
  name_prefix                           = "selectai_with_rag_app_demo"
  instance_shape                        = var.instance_shape
  wallet_content                        = module.adb.adb_database.adb_wallet_content
  compute_nsg_id                        = module.adb.compute_nsg_id
}