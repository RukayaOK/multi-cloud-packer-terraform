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

  backend "s3" {
    bucket = "packerbucket123"
    key    = "this"
    region = "us-west-2"
  }

}

provider "aws" {
  region = var.region
}

provider "http" {
  # Configuration options
}