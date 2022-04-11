terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.72.0"
    }
  }
}

provider "yandex" {
  service_account_key_file = file("/home/aldav/aldav.json")
  cloud_id  = "b1gle7sv6t64fseommi2"
  folder_id = "b1g5ttmlo94iceu07i72"
  zone      = "ru-central1-b"
}

resource "yandex_compute_instance" "vm" {
  count       = "2"
  name        = "terraform-${count.index}"

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

  provisioner "remote-exec" {
    inline = ["sudo apt update", "sudo apt install python -y", "echo Done!"]

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host = self.network_interface[0].nat_ip_address
    }
  }
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm.0.network_interface.0.nat_ip_address
}

output "external_ip_address_vm_2" {
  value = yandex_compute_instance.vm.1.network_interface.0.nat_ip_address
}

resource "local_file" "hosts_inv" {
  content = templatefile("${path.module}/hosts.tpl",
    {
      deploy = yandex_compute_instance.vm.0.network_interface.0.nat_ip_address
      stage = yandex_compute_instance.vm.1.network_interface.0.nat_ip_address
    }
  )
  filename = "../ansible/inventory/hosts.inv"
}