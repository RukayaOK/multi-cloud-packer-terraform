variable "region" {
  type        = string
  description = "AWS region to deploy network"
}

variable "aws_iam_user_name" {
  type        = string
  description = "Packer user name"
}

variable "aws_iam_policy_name" {
  type        = string
  description = "Name for Packer policy"
}

variable "aws_iam_policy_definition" {
  type        = string
  description = "Definition for Packer policy"
}

variable "aws_policy_file_path" {
  type        = string
  description = "File path for Packer policy"
}

variable "policy_attachment_name" {
  type        = string
  description = "Name for Packer policy attachment"
}

variable "aws_secretsmanager_secret_access_key_name" {
  type        = string
  description = "Secret Manager Access Key Name"
}

variable "aws_secretsmanager_secret_access_description" {
  type        = string
  description = "Secret Manager Access Key Description"
}

variable "aws_secretsmanager_secret_version_secret_key_name" {
  type        = string
  description = "Secret Manager Secret Key Name"
}

variable "aws_secretsmanager_secret_version_secret_key_description" {
  type        = string
  description = "Secret Manager Secret Key Description"
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

variable "github_repository" {
  type        = string
  description = "Name of the github repository"
}
variable "github_environment" {
  type        = string
  default     = ""
  description = "Name of github envivonment for azure image pipeline. Only relevant for github organisations."
}
