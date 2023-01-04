packer {
  required_plugins {
    azure = {
      version = ">= 1.3.1"
      source  = "github.com/hashicorp/azure"
    }
    amazon = {
      version = ">= 1.1.6"
      source  = "github.com/hashicorp/amazon"
    }
    googlecompute = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/googlecompute"
    }
  }
}