terraform {
  required_version = ">= 0.12"
  backend "gcs" {
    bucket = "packer-terraform"
    prefix = "packer/bootstrap-tfsate"
  }
}
provider "google" {
  project     = var.project
  region      = var.region
  credentials = file("${path.module}/${var.GOOGLE_APPLICATION_CREDENTIALS}")
}