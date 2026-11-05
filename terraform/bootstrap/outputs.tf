output "infra_key" {
  description = "Авторизованный ключ аккаунта основной инфраструктуры; хранить вне Git."
  sensitive   = true
  value = {
    id                 = yandex_iam_service_account_key.infra.id
    service_account_id = yandex_iam_service_account.infra.id
    created_at         = yandex_iam_service_account_key.infra.created_at
    key_algorithm      = "RSA_2048"
    public_key         = yandex_iam_service_account_key.infra.public_key
    private_key        = yandex_iam_service_account_key.infra.private_key
  }
}

output "backend_credentials" {
  description = "S3 credentials аккаунта backend; хранить вне Git."
  sensitive   = true
  value = {
    access_key = yandex_iam_service_account_static_access_key.backend.access_key
    secret_key = yandex_iam_service_account_static_access_key.backend.secret_key
  }
}

output "bucket_name" {
  description = "Имя bucket для state основной инфраструктуры."
  value       = yandex_storage_bucket.state.bucket
}
output "infra_service_account_id" {
  description = "ID аккаунта управления Compute и VPC."
  value       = yandex_iam_service_account.infra.id
}
output "backend_service_account_id" {
  description = "ID аккаунта доступа к bucket state."
  value       = yandex_iam_service_account.backend.id
}
