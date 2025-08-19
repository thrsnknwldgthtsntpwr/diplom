terraform {
    required_providers {
        yandex = {
            source = "yandex-cloud/yandex"
        }
    }
}

provider "yandex" {
    zone = var.default_zone
    service_account_key_file = var.authorized_key_file
    cloud_id = var.cloud_id
    folder_id = var.folder_id
}