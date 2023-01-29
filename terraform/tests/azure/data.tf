data "http" "ip" {
  url = "https://ifconfig.me/ip"
}

data "azurerm_image" "main" {
  name                = var.image_name
  resource_group_name = var.image_resource_group_name
}

