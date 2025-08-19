resource "yandex_storage_bucket" "terraform_state" {
  bucket     = var.bucket_name
  default_storage_class = var.storage_class
}