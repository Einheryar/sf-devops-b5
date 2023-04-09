variable "instance_image_family" {
  description	= "Instance Family Image"
  type		= string
  default	= "lamp"
}


variable "vpc_subnet_id" {
  description 	= "VPC Subnet Network ID"
  type		= string
}

variable "instance_zone" {
  description	= "Instance Zone"
  type		= string
  default	= "ru-central1-a"
}
