locals {
  cloud_init = {
    users = [{
      name                = var.ssh_user
      groups              = ["sudo"]
      shell               = "/bin/bash"
      sudo                = "ALL=(ALL) NOPASSWD:ALL"
      ssh_authorized_keys = [var.ssh_public_key]
    }]
    ssh_pwauth   = false
    disable_root = true
  }
}
