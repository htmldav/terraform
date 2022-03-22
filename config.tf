terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.72.0"
    }
  }
}

provider "yandex" {
  token     = "AQAAAAAKvtVLAATuwSbAxJe__kfvqmHjQdZqggs"
  cloud_id  = "b1gle7sv6t64fseommi2"
  folder_id = "b1g5ttmlo94iceu07i72"
  zone      = "ru-central1-b"
}

resource "yandex_compute_instance" "vm-1" {
  name        = "terraform1"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd80jfslq61mssea4ejn"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }
 
  metadata = {
    ssh-keys = "ssh-rsa ubuntu:AAAAB3NzaC1yc2EAAAADAQABAAABAQCXgG/TOpdnA3pJTyi4UWv7xfLD7DrRWSkkNPi3W5fAQa0tDpsinG9l9fJCdgKPlsgl6wkHm6gFRu21kY9NZ5OzEB9rwPzQ6eC9shblL+eLgWdHhpKZPb6SuYJBg30ka38m9CD84LWPbQkuR2mvzrgeE/21OwoLmBDKndI0U/8NwdxWXv7BWL04kmhgsx0BaZRXZwf0gB3Qg0g1YKUG6Fr5JGtgnR3CvHXe1DT2Aent8E2RpNfFNaAm9NYiYLNnbq85t5iJKH6gqddMGiuQwlQaI6PIMQpJ02t1yTKiqTnL1IQJNYQbL85bHk13HLtAwMglLszBadE+4eV2ZezaZuvb rsa-key-20220121"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

