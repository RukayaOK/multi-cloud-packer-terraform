terraform {
  required_version = ">= 1.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.37.0"
    }
    github = {
      source  = "integrations/github"
      version = "5.12.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.31.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.2.1"
    }
  }

  #backend "local" {}

  backend "azurerm" {
    resource_group_name  = "rok-terraform-rg-do-not-delete"
    storage_account_name = "terrates901"
    container_name       = "state"
    key                  = "packer.tfstate"
  }
}

provider "github" {
  # Configuration options
}

provider "azurerm" {
  # Configuration options
  features {}
}

provider "azuread" {
  # Configuration options
}

provider "http" {
  # Configuration options
}