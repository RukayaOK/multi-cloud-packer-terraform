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
  backend "gcs" {
    bucket = "packer-terraform"
    prefix = "packer/multi-cloud-tfsate"
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