data "terraform_remote_state" "azure" {
  backend = "azurerm"

  config = {
    resource_group_name  = "rok-terraform-rg-do-not-delete"
    storage_account_name = "terrates901"
    container_name       = "state"
    key                  = "azure-packer-test.tfstate"
  }
}

data "terraform_remote_state" "aws" {
  backend = "azurerm"

  config = {
    resource_group_name  = "rok-terraform-rg-do-not-delete"
    storage_account_name = "terrates901"
    container_name       = "state"
    key                  = "aws-packer-test.tfstate"
  }
}

data "terraform_remote_state" "gcp" {
  backend = "azurerm"

  config = {
    resource_group_name  = "rok-terraform-rg-do-not-delete"
    storage_account_name = "terrates901"
    container_name       = "state"
    key                  = "gcp-packer-test.tfstate"
  }
}
