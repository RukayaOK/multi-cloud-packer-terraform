resource "azurerm_resource_group" "packer_artifacts_resource_group" {
  name     = var.packer_artifacts_resource_group
  location = var.location
}

resource "azurerm_resource_group" "packer_build_resource_group" {
  name     = var.packer_build_resource_group
  location = var.location
}

resource "azurerm_resource_group" "packer_key_vault_resource_group" {
  name     = var.packer_key_vault_resource_group
  location = var.location
}

resource "azurerm_resource_group" "packer_shared_image_gallery_resource_group" {
  name     = var.packer_shared_image_gallery_resource_group
  location = var.location
}