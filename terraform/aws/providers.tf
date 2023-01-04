terraform {
  backend "s3" {
    bucket = "packerbucket123"
    key    = "this"
    region = "us-west-2"
  }
}

provider "aws" {
  region = var.region
}
