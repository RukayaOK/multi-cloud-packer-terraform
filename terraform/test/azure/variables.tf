variable "location" {
  type        = string
  description = "description"
}

variable "resource_group_name" {
  type        = string
  description = "description"
}

variable "vnet_name" {
  type        = string
  description = "description"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "description"
}

variable "subnet_name" {
  type        = string
  description = "description"
}

variable "subnet_address_space" {
  type        = list(string)
  description = "description"
}

variable "subnet_nsg_name" {
  type        = string
  description = "description"
}

variable "http_allowed_ip_addresses" {
  type        = list(string)
  description = "CIDR block for security group http ingress"
}

variable "ssh_allowed_ip_addresses" {
  type        = list(string)
  description = "CIDR block for security group ssh ingress"
}


variable "public_ip_name" {
  type        = string
  description = "description"
}

variable "public_ip_allocation_method" {
  type        = string
  description = "description"
}

variable "nic_name" {
  type        = string
  description = "description"
}

variable "nic_ip_config_name" {
  type        = string
  description = "description"
}

variable "nic_ip_config_private_ip_allocation_method" {
  type        = string
  description = "description"
}

variable "vm_name" {
  type        = string
  description = "description"
}

variable "vm_size" {
  type        = string
  description = "description"
}

variable "image_name" {
  type        = string
  description = "description"
}

variable "image_resource_group_name" {
  type        = string
  description = "description"
}

variable "storage_os_disk_name" {
  type        = string
  description = "description"
}

variable "storage_os_disk_caching" {
  type        = string
  description = "description"
}

variable "storage_os_disk_managed_disk_type" {
  type        = string
  description = "description"
}

variable "key_pair_name" {
  type        = string
  description = "Azure Key Pair Name"
}

variable "vm_hostname" {
  type        = string
  description = "description"
}

variable "vm_admin_username" {
  type        = string
  description = "description"
}

