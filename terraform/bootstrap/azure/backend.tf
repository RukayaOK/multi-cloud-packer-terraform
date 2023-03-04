terraform {
  backend "azurerm" {
    resource_group_name  = "some-rg-3"
    storage_account_name = "somesgterahs"
    container_name       = "tfstates"
    key                  = "azure-packer-bootstrap.tfstate"
  }
}