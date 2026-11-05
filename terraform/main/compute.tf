resource "yandex_compute_instance" "nodes" {
  for_each    = var.nodes
  name        = "${var.project_name}-${each.key}"
  hostname    = "${var.project_name}-${each.key}"
  zone        = var.subnets[each.value.subnet].zone
  platform_id = var.platform_id
  labels      = merge(var.labels, { project = var.project_name, role = each.value.role })
  resources {
    cores         = var.vm_resources.cores
    memory        = var.vm_resources.memory
    core_fraction = var.vm_resources.core_fraction
  }
  scheduling_policy {
    preemptible = each.value.preemptible
  }
  boot_disk {
    initialize_params {
      name     = "${var.project_name}-${each.key}-boot"
      image_id = var.image_id
      type     = var.disk_type
      size     = var.disk_size
    }
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.nodes[each.value.subnet].id
    ip_address         = each.value.ip
    nat                = var.assign_public_ip
    security_group_ids = concat([yandex_vpc_security_group.nodes.id], each.value.role == "control-plane" ? [yandex_vpc_security_group.control.id] : [])
  }
  metadata = {
    user-data = "#cloud-config\n${yamlencode(local.cloud_init)}"
  }
  allow_stopping_for_update = true
}
