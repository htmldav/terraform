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
    subnet_id = "e2l4q2u32och1eqtqs2h"
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

resource "local_file" "inventory" {
    filename = "./host.ini"
    content = <<-EOT
      [build]
      ${yandex_compute_instance.vm-1.network_interface.0.nat_ip_address}
    EOT
}