resource "azurerm_shared_image_gallery" "packer_shared_image_gallery" {
  name                = var.packer_shared_image_gallery
  resource_group_name = azurerm_resource_group.packer_shared_image_gallery_resource_group.name
  location            = azurerm_resource_group.packer_shared_image_gallery_resource_group.location
  description         = var.packer_shared_image_gallery_description
}

resource "azurerm_shared_image" "centos_image_definition" {
  name                = "centos-image"
  gallery_name        = azurerm_shared_image_gallery.packer_shared_image_gallery.name #var.packer_shared_image_gallery 
  resource_group_name = azurerm_resource_group.packer_shared_image_gallery_resource_group.name
  location            = azurerm_resource_group.packer_shared_image_gallery_resource_group.location
  os_type             = "Linux"
  identifier {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.3"
  }
}