locals {
  bootstrap_service_account_id = jsondecode(file(var.bootstrap_key_file)).service_account_id
}
