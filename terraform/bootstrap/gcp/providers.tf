terraform {
  required_version = ">= 0.12"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.50.0"
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
    key                  = "gcp-packer-bootstrap.tfstate"
  }
}
provider "google" {
  project     = var.project
  region      = var.region
  credentials = file("${path.module}/${var.GOOGLE_APPLICATION_CREDENTIALS}")
}

provider "http" {
  # Configuration options
}