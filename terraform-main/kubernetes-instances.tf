locals {
  subnets = {
    "subnet-ru-central1-a" = { zone = "ru-central1-a", cidr = "192.168.100.0/24" },
    "subnet-ru-central1-b" = { zone = "ru-central1-b", cidr = "192.168.110.0/24" },
    "subnet-ru-central1-d" = { zone = "ru-central1-d", cidr = "192.168.120.0/24" }
  }
  vms = {
    "vm-ru-central1-a" = { zone = "ru-central1-a", subnet_name = "subnet-ru-central1-a" },
    "vm-ru-central1-b" = { zone = "ru-central1-b", subnet_name = "subnet-ru-central1-b" },
    "vm-ru-central1-d" = { zone = "ru-central1-d", subnet_name = "subnet-ru-central1-d" }
  }
}

resource "yandex_vpc_network" "kuber-network" {
    name = "kuber-network"
}

resource "yandex_vpc_subnet" "subnet" {
  for_each       = local.subnets
  name           = each.key
  zone           = each.value.zone
  network_id     = yandex_vpc_network.kuber-network.id
  v4_cidr_blocks = [each.value.cidr]
}

resource "yandex_compute_instance" "kuber-vm" {
  for_each    = local.vms
  name        = each.key
  platform_id = var.platform_id
  zone        = each.value.zone
  allow_stopping_for_update = true
  resources {
    cores  = var.vm-cores
    memory = var.vm-ram
    core_fraction = var.vm-core_fraction
  }
  scheduling_policy {
    preemptible = var.vm-preemptible
  }
  boot_disk {
    initialize_params {
      image_id = var.vm-disk-image_id
      type = var.vm-disk-type
      size = var.vm-disk-size
    }
  }
  network_interface {
    index = 0
    subnet_id = yandex_vpc_subnet.subnet[each.value.subnet_name].id
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("./authorized_keys/id_ed25519.pub")}"
  }
}

output "Kubernetes-instances-private-IPs" {
  value = { for k, v in yandex_compute_instance.kuber-vm : k => v.network_interface.0.ip_address }
  description = "Private IP addresses of the created instances"
}
output "Kubernetes-instances-public-IPs" {
  value = { for k, v in yandex_compute_instance.kuber-vm : k => v.network_interface.0.nat_ip_address }
  description = "Public IP addresses of the created instances"
}