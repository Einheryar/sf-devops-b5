terraform {
  required_providers {
    yandex = {
      source	= "yandex-cloud/yandex"
      version	= "0.86.0" # Фиксируем версию провайдера
    }
  }
  required_version = ">= 0.13"
}

data "yandex_compute_image" "my_image" {
  family = var.instance_image_family
}

resource "yandex_compute_instance" "vm" {
  name        = "vm-terraform-${var.instance_image_family}"
  platform_id = "standard-v1"
  zone        = var.instance_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image.id
    }
  }

  network_interface {
    subnet_id = var.vpc_subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/yac/id_rsa.pub")}"
  }
}
