terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.52.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.2.1"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rok-terraform-rg-do-not-delete"
    storage_account_name = "terrates901"
    container_name       = "state"
    key                  = "aws-packer-bootstrap.tfstate"
  }

}

provider "aws" {
  region = var.region
}

provider "http" {
  # Configuration options
}