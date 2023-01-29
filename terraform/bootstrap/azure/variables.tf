variable "packer_azuread_application" {
  type        = string
  description = "Name of application and service principal that will deply packer images"
}

variable "image_delete_role" {
  type        = string
  description = "Name of custom role that can delete Images"
}

variable "location" {
  type        = string
  description = "Location where Azure resources will be deployed"
}

variable "packer_artifacts_resource_group" {
  type        = string
  description = "Resource group to store packer images"
}

variable "packer_build_resource_group" {
  type        = string
  description = "Resource group where packer image resources are built during creation"
}

variable "packer_key_vault_resource_group" {
  type        = string
  description = "Resource group to store packer application secrets"
}

variable "packer_shared_image_gallery_resource_group" {
  type        = string
  description = "Resource group to store packer shared image gallery"
}

variable "packer_key_vault" {
  type        = string
  description = "Key vault to store packer application secrets"
}

variable "github_repository" {
  type        = string
  description = "Name of the github repository"
}
variable "github_environment" {
  type        = string
  default     = ""
  description = "Name of github envivonment for azure image pipeline. Only relevant for github organisations."
}

variable "packer_build_vnet" {
  type        = string
  description = "VNET for packer build resources"
}

variable "packer_build_subnet" {
  type        = string
  description = "Subnet for packer build resources"
}

variable "packer_build_vnet_address_space" {
  type        = list(string)
  description = "VNET address space for packer build resources"
}

variable "packer_build_subnet_address_space" {
  type        = list(string)
  description = "Subnet address space for packer build resources"
}

variable "packer_build_subnet_nsg" {
  type        = string
  description = "NSG for Subnet for packer build resources"
}

variable "allowed_ip_addresses" {
  type        = list(string)
  description = "IP address allowed to access resources"
  default     = []
}

variable "packer_shared_image_gallery" {
  type        = string
  description = "Name of shared gallery for packer images"
}

variable "packer_shared_image_gallery_description" {
  type        = string
  description = "Description of shared gallery for packer images"
}