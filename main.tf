variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

terraform {
  required_providers {
    yandex = {
      source	= "yandex-cloud/yandex"
      version	= "0.86.0" # Фиксируем версию провайдера
    }
  }
  required_version = ">= 0.13"
  backend "s3" {
    endpoint					= "storage.yandexcloud.net"
    bucket					= "tf-state-bucket-sf-devops"
    region					= "ru-central1"
    key						= "b5-5-3/2vm.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

# Документация к провайдеру тут https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart#configure-provider
# Настраиваем the Yandex.Cloud provider
provider "yandex" {
  service_account_key_file	= file("~/yac_keys/terraform-sa_key.json")
  cloud_id			= var.cloud_id
  folder_id			= var.folder_id
  zone				= "ru-central1-a"
}

resource "yandex_vpc_network" "network_terraform_1" {
  name = "network-terraform-1"
}

resource "yandex_vpc_subnet" "subnet_terraform_1" {
  name           = "subnet-terraform-1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network_terraform_1.id
  v4_cidr_blocks = ["192.168.0.0/24"]
}

resource "yandex_vpc_subnet" "subnet_terraform_2" {
  name           = "subnet-terraform-2"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network_terraform_1.id
  v4_cidr_blocks = ["192.168.1.0/24"]
}

module "vm_1" {
  source		= "./modules/instance"
  instance_image_family	= "lemp"
  vpc_subnet_id		= yandex_vpc_subnet.subnet_terraform_1.id
  instance_zone		= "ru-central1-a"
}

module "vm_2" {
  source		= "./modules/instance"
  instance_image_family	= "lamp"
  vpc_subnet_id		= yandex_vpc_subnet.subnet_terraform_2.id
  instance_zone		= "ru-central1-b"
}
