# output "adb_database" {
#  value = module.adb.adb_database
# }

output "app_url" {
  value = "http://${module.compute.public_ip[0]}:3000"
}
