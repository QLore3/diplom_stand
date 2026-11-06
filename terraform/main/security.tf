resource "yandex_vpc_security_group" "nodes" {
  name       = "${var.project_name}-nodes"
  network_id = yandex_vpc_network.diplom.id
  ingress {
    description       = "Cluster communication within this security group"
    protocol          = "ANY"
    predefined_target = "self_security_group"
  }
  ingress {
    description    = "SSH from administrator"
    protocol       = "TCP"
    port           = var.ssh_port
    v4_cidr_blocks = [var.admin_cidr]
  }
  egress {
    description    = "Updates, images and external APIs"
    protocol       = "ANY"
    v4_cidr_blocks = var.egress_cidrs
  }
}

resource "yandex_vpc_security_group" "control" {
  name       = "${var.project_name}-control-entry"
  network_id = yandex_vpc_network.diplom.id
  ingress {
    description    = "Kubernetes API from administrator"
    protocol       = "TCP"
    port           = var.kubernetes_api_port
    v4_cidr_blocks = [var.admin_cidr]
  }
  ingress {
    description    = "Authenticated WireGuard tunnel for application delivery"
    protocol       = "UDP"
    port           = var.delivery_wireguard_port
    v4_cidr_blocks = var.delivery_wireguard_cidrs
  }
  ingress {
    description    = "Application and Grafana HTTP entry point"
    protocol       = "TCP"
    port           = var.http_port
    v4_cidr_blocks = var.http_cidrs
  }
}
