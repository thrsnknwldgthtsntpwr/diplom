variable "cloud_id" {
    type = string
    description = "Yandex.Cloud Identifier"
}
variable "folder_id" {
    type = string
    description = "Folder Identifier"
}
variable "default_zone" {
    type = string
    description = "Default Zone"
}
variable "authorized_key_file" {
    type = string
    description = "Path to Storage.editor Service Account's authorized_key file"
}
variable "storage_class" {
    type = string
    description = "Bucket's storage class (STANDARD/COLD/ICE)"
}