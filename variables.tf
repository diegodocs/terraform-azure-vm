variable "business_product_name" {
  type = string
}

variable "suffix" {
  type = string
}

variable "resource_location" {
  type    = string
  default = "eastus2"
}

variable "vm_admin_username" {
  type    = string
  default = "adminuser"
}

variable "vm_admin_password" {
  type    = string
  default = "P@$s0rd001!"
}

variable "vm_publisher" {
  type = string
}

variable "vm_offer" {
  type = string
}

variable "vm_sku" {
  type = string
}

variable "vm_version" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "vm_disk_data_size_gb" {
  default = 30
}

variable "vnet_resource_group_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "owner" {
  type = string
}

variable "costcenter" {
  type = string
}

variable "monitoring" {
  type = string
}

variable "env" {
  type = string
}