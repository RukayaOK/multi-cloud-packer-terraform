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
    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
    local = {
      source = "hashicorp/local"
      version = "2.2.3"
    }
  }

  backend "s3" {
    bucket = "packerbucket123"
    key    = "nginx"
    region = "us-west-2"
  }
}

provider "aws" {
  region = var.region
}

provider "http" {
  # Configuration options
}