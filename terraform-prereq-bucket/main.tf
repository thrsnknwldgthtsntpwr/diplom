resource "yandex_storage_bucket" "terraform_state" {
  bucket     = "terraform-state-${var.folder_id}"
  default_storage_class = var.storage_class
  force_destroy = true
  acl = "private"
  access_key = yandex_iam_service_account_static_access_key.sa_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa_key.secret_key
}

resource "yandex_iam_service_account" "sa" {
  name = "sa"
  folder_id = var.folder_id
}

resource "yandex_iam_service_account_static_access_key" "sa_key" {
  service_account_id = yandex_iam_service_account.sa.id
}

resource "yandex_resourcemanager_folder_iam_binding" "storage_editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  members   = ["serviceAccount:${yandex_iam_service_account.sa.id}"]
}

output "bucket_name" {
  value = yandex_storage_bucket.terraform_state.bucket
}

output "access_key" {
  value = yandex_iam_service_account_static_access_key.sa_key.access_key
}

output "secret_key" {
  value = yandex_iam_service_account_static_access_key.sa_key.secret_key
  sensitive = true
}