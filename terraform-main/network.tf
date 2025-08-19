resource "yandex_vpc_network" "vpc" {
    name = "vpc"
}

resource "yandex_vpc_subnet" "subnet-a" {
    name = "ru-central1-a_subnet"
    zone = "ru-central1-a"
    v4_cidr_blocks = ["192.168.10.0/24"]
    network_id = yandex_vpc_network.vpc.id
}

resource "yandex_vpc_subnet" "subnet-b" {
    name = "ru-central1-b_subnet"
    zone = "ru-central1-b"
    v4_cidr_blocks = ["192.168.20.0/24"]
    network_id = yandex_vpc_network.vpc.id
}

resource "yandex_vpc_subnet" "subnet-d" {
    name = "ru-central1-d_subnet"
    zone = "ru-central1-d"
    v4_cidr_blocks = ["192.168.30.0/24"]
    network_id = yandex_vpc_network.vpc.id
}

