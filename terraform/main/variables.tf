variable "cloud_id" {
  description = "ID облака Yandex Cloud."
  type        = string
}

variable "folder_id" {
  description = "ID выделенного каталога диплома."
  type        = string
}

variable "project_name" {
  description = "Префикс имён ресурсов и метка проекта."
  type        = string
  default     = "diplom"
}

variable "infra_key_file" {
  description = "Путь к JSON-ключу ограниченного аккаунта Terraform."
  type        = string
}

variable "admin_cidr" {
  description = "IPv4 CIDR администратора для SSH и Kubernetes API."
  type        = string
  validation {
    condition     = can(cidrnetmask(var.admin_cidr)) && !endswith(var.admin_cidr, "/0")
    error_message = "Укажите ограниченный IPv4 CIDR; доступ /0 запрещён."
  }
}

variable "ssh_public_key" {
  description = "Публичный SSH-ключ администратора."
  type        = string
}

variable "ssh_user" {
  description = "Пользователь ОС для SSH и Ansible."
  type        = string
  default     = "ubuntu"
}

variable "image_id" {
  description = "ID закреплённого образа ОС с поддержкой выбранного размера диска."
  type        = string
}

variable "subnets" {
  description = "Подсети: ключ, зона доступности и IPv4 CIDR."
  type = map(object({
    zone = string
    cidr = string
  }))
  validation {
    condition     = alltrue([for subnet in values(var.subnets) : can(cidrnetmask(subnet.cidr))])
    error_message = "Каждая подсеть должна содержать корректный IPv4 CIDR."
  }
}

variable "nodes" {
  description = "ВМ: ключ подсети, частный IP, роль и прерываемость."
  type = map(object({
    subnet      = string
    ip          = string
    role        = string
    preemptible = bool
  }))
  validation {
    condition     = alltrue([for node in values(var.nodes) : contains(["control-plane", "worker"], node.role)])
    error_message = "Роль ВМ: control-plane или worker."
  }
  validation {
    condition     = alltrue([for node in values(var.nodes) : contains(keys(var.subnets), node.subnet)])
    error_message = "Подсеть каждой ВМ должна присутствовать в subnets."
  }
}

variable "platform_id" {
  description = "Платформа Compute Cloud."
  type        = string
  default     = "standard-v3"
}

variable "vm_resources" {
  description = "Ресурсы каждой ВМ: vCPU, RAM в ГиБ и гарантированная доля CPU в процентах."
  type = object({
    cores         = number
    memory        = number
    core_fraction = number
  })
  default = {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
}

variable "disk_type" {
  description = "Тип загрузочного сетевого диска."
  type        = string
  default     = "network-hdd"
}

variable "disk_size" {
  description = "Размер загрузочного диска каждой ВМ в ГиБ."
  type        = number
  default     = 10
}

variable "assign_public_ip" {
  description = "Выделять ВМ публичные IPv4 для SSH и исходящих соединений."
  type        = bool
  default     = true
}

variable "labels" {
  description = "Дополнительные метки ВМ."
  type        = map(string)
  default     = {}
}

variable "ssh_port" {
  description = "Порт SSH в правилах security group."
  type        = number
  default     = 22
}

variable "kubernetes_api_port" {
  description = "Порт Kubernetes API на control plane."
  type        = number
  default     = 6443
}

variable "http_port" {
  description = "Порт внешнего HTTP для приложения и Grafana."
  type        = number
  default     = 80
}

variable "http_cidrs" {
  description = "IPv4 CIDR клиентов внешнего HTTP."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "egress_cidrs" {
  description = "Разрешённые IPv4 CIDR исходящих соединений."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
