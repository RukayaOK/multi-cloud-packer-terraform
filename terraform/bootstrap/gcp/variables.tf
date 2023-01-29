variable "GOOGLE_APPLICATION_CREDENTIALS" {
  type        = string
  description = "Path to gcp credentials file"
}

# define GCP region
variable "region" {
  type        = string
  description = "GCP region"
}

# define GCP project name
variable "project" {
  type        = string
  description = "GCP project name"
}

# Network
variable "vpc_name" {
  type        = string
  description = "VPC name"
}

variable "subnet_name" {
  type        = string
  description = "Subnet name"
}

variable "ip_cidr_range" {
  type        = string
  description = "IP CIDR name"
}

variable "internal_firewall_name" {
  type        = string
  description = "Internal Firewall name"
}

variable "ssh_firewall_name" {
  type        = string
  description = "SSH Firewall name"
}

variable "allowed_ip_addresses" {
  type        = list(string)
  description = "Allowed IP addresses"
}

# Service Account
variable "packer_account_id" {
  type        = string
  description = "Service Account ID"
}

variable "packer_account_name" {
  type        = string
  description = "Service Account Name"
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
