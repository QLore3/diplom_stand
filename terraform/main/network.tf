resource "yandex_vpc_network" "diplom" {
  name = "${var.project_name}-network"
}

resource "yandex_vpc_subnet" "nodes" {
  for_each       = var.subnets
  name           = "${var.project_name}-${each.key}"
  zone           = each.value.zone
  network_id     = yandex_vpc_network.diplom.id
  v4_cidr_blocks = [each.value.cidr]
}
