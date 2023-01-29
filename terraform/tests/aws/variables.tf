variable "region" {
  type        = string
  description = "AWS region to deploy network"
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC block for packer build network"
}

variable "availability_zone" {
  type        = string
  description = "Subnet Availability Zone"
}

variable "igw_route_destination_cidr_block" {
  type        = string
  description = "Internet Gateway destination route"
}

variable "security_group_name" {
  type        = string
  description = "Name of the security group"
}

variable "security_group_description" {
  type        = string
  description = "Description of the security group"
}

variable "allowed_ip_addresses" {
  type        = list(string)
  description = "CIDR block for security group ingress"
  default     = []
}

variable "egress_cidr_blocks" {
  type        = list(string)
  description = "CIDR block for security group egress"
}

variable "key_pair_name" {
  type        = string
  description = "AWS Key Pair Name"
}

variable ami_id {
  type = string
  description = "description"
}

variable instance_type {
  type = string
  description = "description"
}