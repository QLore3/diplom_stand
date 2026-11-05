resource "yandex_iam_service_account" "infra" {
  name        = "${var.project_name}-tf-infra"
  description = "Terraform compute and VPC only; no IAM administration"
}

resource "yandex_resourcemanager_folder_iam_member" "infra" {
  for_each  = var.infra_roles
  folder_id = var.folder_id
  role      = each.value
  member    = "serviceAccount:${yandex_iam_service_account.infra.id}"
}

resource "yandex_iam_service_account_key" "infra" {
  service_account_id = yandex_iam_service_account.infra.id
  key_algorithm      = "RSA_2048"
}

resource "yandex_iam_service_account" "backend" {
  name        = "${var.project_name}-tf-backend"
  description = "S3 state access only; bucket ACL, no folder roles"
}

resource "yandex_iam_service_account_static_access_key" "backend" {
  service_account_id = yandex_iam_service_account.backend.id
  description        = "Terraform S3 backend"
}
# The initial administrator is used only to provision the bucket.
resource "yandex_iam_service_account_static_access_key" "bootstrap" {
  service_account_id = local.bootstrap_service_account_id
  description        = "Diploma bootstrap bucket administration"
}

resource "yandex_storage_bucket" "state" {
  bucket        = var.bucket_name
  folder_id     = var.folder_id
  access_key    = yandex_iam_service_account_static_access_key.bootstrap.access_key
  secret_key    = yandex_iam_service_account_static_access_key.bootstrap.secret_key
  max_size      = var.bucket_max_size
  force_destroy = false
  anonymous_access_flags {
    read        = false
    list        = false
    config_read = false
  }
  versioning {
    enabled = true
  }
  grant {
    id          = yandex_iam_service_account.backend.id
    type        = "CanonicalUser"
    permissions = ["READ", "WRITE"]
  }
  grant {
    id          = local.bootstrap_service_account_id
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
  }
  lifecycle {
    prevent_destroy = true
  }
}
