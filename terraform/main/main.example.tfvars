cloud_id       = "YOUR_CLOUD_ID"
folder_id      = "YOUR_FOLDER_ID"
infra_key_file = "/absolute/path/to/infra-key.json"
admin_cidr     = "203.0.113.1/32"
ssh_public_key = "ssh-ed25519 YOUR_PUBLIC_KEY comment"
image_id       = "YOUR_IMAGE_ID"

subnets = {
  a = { zone = "ru-central1-a", cidr = "10.20.10.0/24" }
  b = { zone = "ru-central1-b", cidr = "10.20.20.0/24" }
  d = { zone = "ru-central1-d", cidr = "10.20.30.0/24" }
}

nodes = {
  control = { subnet = "a", ip = "10.20.10.10", role = "control-plane", preemptible = false }
  worker1 = { subnet = "a", ip = "10.20.10.11", role = "worker", preemptible = true }
  worker2 = { subnet = "d", ip = "10.20.30.10", role = "worker", preemptible = true }
}

vm_resources = {
  cores         = 2
  memory        = 2
  core_fraction = 20
}
disk_type = "network-hdd"
disk_size = 10
