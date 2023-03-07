terraform {
  backend "azurerm" {
    resource_group_name  = "my-resource-group"
    storage_account_name = "uniquenamme1234"
    container_name       = "somecontainer1234"
    key                  = "tf-states"
  }
}