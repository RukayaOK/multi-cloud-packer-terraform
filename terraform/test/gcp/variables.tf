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

variable "http_firewall_name" {
  type        = string
  description = "HTTP Firewall name"
}

variable "http_allowed_ip_addresses" {
  type        = list(string)
  description = "CIDR block for security group http ingress"
}

variable "ssh_allowed_ip_addresses" {
  type        = list(string)
  description = "CIDR block for security group ssh ingress"
}

variable "zone" {
  type        = string
  description = "description"
}


variable "ip_name" {
  type        = string
  description = "description"
}

variable "instance_name" {
  type        = string
  description = "description"
}

variable "instance_type" {
  type        = string
  description = "description"
}

variable "image_name" {
  type        = string
  description = "description"
}