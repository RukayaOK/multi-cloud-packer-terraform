variable "AZURE_CLIENT_ID" {
  type        = string
  description = "The ID of the Application"
  default     = ""
}

variable "AZURE_CLIENT_SECRET" {
  type        = string
  description = "The secret for the Service Principal"
  default     = ""
}

variable "AZURE_SUBSCRIPTION_ID" {
  type        = string
  description = "The subscription your Packer resources will be created in."
  default     = ""
}

variable "AZURE_TENANT_ID" {
  type        = string
  description = "The tenant your Packer resources will be created in."
  default     = ""
}

variable "build_resource_group_name" {
  type        = string
  description = "Resource group where packer images are built"
  default     = ""
}

variable "virtual_network_name" {
  type        = string
  description = "VNET for packer build resources"
  default     = ""
}

variable "virtual_network_subnet_name" {
  type        = string
  description = "Subnet for packer build resources"
  default     = ""
}

variable "private_virtual_network_with_public_ip" {
  type        = string
  description = "Whether Packer VM is created with a public IP address or not"
  default     = ""
}

variable "vm_size" {
  type        = string
  description = "Size of the VM being built"
  default     = ""
}

variable "managed_image_resource_group_name" {
  type        = string
  description = "Resource group to store packer images"
  default     = ""
}

variable "managed_image_name" {
  type        = string
  description = "Name of the packer image"
  default     = ""
}

variable "os_type" {
  type        = string
  description = "OS Type of the packer image"
  default     = ""
}

variable "image_publisher" {
  type        = string
  description = "Publisher of the base image for your packer image"
  default     = ""
}

variable "image_offer" {
  type        = string
  description = "Offer name of the base image for your packer image"
  default     = ""
}

variable "image_sku" {
  type        = string
  description = "SKU of the base image for your packer image"
  default     = ""
}

variable "azure_tags_department" {
  type        = string
  description = "Department tag for the packer image"
  default     = ""
}

variable "azure_tags_task" {
  type        = string
  description = "Task tag for the packer image"
  default     = ""
}

variable "shared_image_gallery_destination_resource_group_name" {
  type        = string
  description = "Resource Group of the Shared Image Gallery"
  default     = ""
}

variable "shared_image_gallery_destination_gallery_name" {
  type        = string
  description = "Name of the Shared Image Gallery"
  default     = ""
}

variable "managed_image_version" {
  type        = string
  description = "Version of the packer image in the Shared Image Gallery"
  default     = ""
}

variable "managed_image_definition" {
  type        = string
  description = "Image definition the packer image belongs to"
  default     = ""
}

variable "replication_regions" {
  type        = list(string)
  description = "Regions to replicate the packer image to"
  default     = []
}

variable "storage_account_type" {
  type        = string
  description = "Storage account type he packer image is stored in"
  default     = ""
}