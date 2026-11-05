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

variable "bootstrap_key_file" {
  description = "Путь к авторизованному JSON-ключу начального аккаунта."
  type        = string
}

variable "bucket_name" {
  description = "Глобально уникальное имя закрытого bucket для Terraform state."
  type        = string
}

variable "bucket_max_size" {
  description = "Максимальный размер bucket в байтах (по умолчанию 1 ГиБ)."
  type        = number
  default     = 1073741824
}

variable "infra_roles" {
  description = "Роли аккаунта основной инфраструктуры в выделенном каталоге."
  type        = set(string)
  default     = ["compute.editor", "vpc.admin"]
}
