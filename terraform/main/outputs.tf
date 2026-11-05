output "nodes" {
  description = "Адреса, ID и параметры доступа к ВМ кластера."
  value = { for name, vm in yandex_compute_instance.nodes : name => {
    id          = vm.id
    zone        = vm.zone
    public_ip   = vm.network_interface[0].nat_ip_address
    private_ip  = vm.network_interface[0].ip_address
    user        = var.ssh_user
    preemptible = var.nodes[name].preemptible
  } }
}
