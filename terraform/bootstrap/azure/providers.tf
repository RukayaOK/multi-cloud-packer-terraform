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
    null = {
      source = "hashicorp/null"
      version = "3.2.1"
    }
    time = {
      source = "hashicorp/time"
      version = "0.9.1"
    }
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

provider "null" {
  # Configuration options
}

provider "time" {
  # Configuration options
}