variable "gcp_account_credentials" {
  type        = string
  description = "Your aws profile (Must have the EC2 access right)"
  default     = ""
}

variable "gcp_service_account_email" {
  type        = string
  description = "Your aws profile (Must have the EC2 access right)"
  default     = ""
}

variable "project_id" {
  type        = string
  description = "ID of your Project"
  default     = ""
}

variable "source_image" {
  type        = string
  description = "Base Image for Packer Image"
  default     = ""
}

variable "ssh_username" {
  type        = string
  description = "Username for SSH user. Packer will create this."
  default     = ""
}

variable "zone" {
  type        = string
  description = "Availability zone"
  default     = ""
}

variable "disk_size" {
  type        = number
  description = "Size of the disk"
  default     = 4
}

variable "disk_type" {
  type        = string
  description = "Type of disk"
  default     = ""
}

variable "machine_type" {
  type        = string
  description = "Machine Type"
  default     = ""
}

variable "image_family" {
  type        = string
  description = "Desired Image Family name"
  default     = ""
}

variable "image_name" {
  type        = string
  description = "Desired Image name"
  default     = ""
}

variable "image_description" {
  type        = string
  description = "Desired Image description"
  default     = ""
}

variable "network" {
  type        = string
  description = "Your aws profile (Must have the EC2 access right)"
  default     = ""
}

variable "subnetwork" {
  type        = string
  description = "Your aws profile (Must have the EC2 access right)"
  default     = ""
}

variable "metadata" {
  #type        = list(string)
  description = "Your aws profile (Must have the EC2 access right)"
  default     = {}
}