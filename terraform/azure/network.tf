resource "azurerm_virtual_network" "packer_build_vnet" {
  name                = var.packer_build_vnet
  location            = var.location
  resource_group_name = azurerm_resource_group.packer_build_resource_group.name
  address_space       = var.packer_build_vnet_address_space
}

resource "azurerm_subnet" "packer_build_subnet" {
  name                 = var.packer_build_subnet
  resource_group_name  = azurerm_resource_group.packer_build_resource_group.name
  virtual_network_name = azurerm_virtual_network.packer_build_vnet.name
  address_prefixes     = var.packer_build_subnet_address_space
}

resource "azurerm_network_security_group" "packer_build_subnet_nsg" {
  name                = var.packer_build_subnet_nsg
  location            = azurerm_resource_group.packer_build_resource_group.location
  resource_group_name = azurerm_resource_group.packer_build_resource_group.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefixes    = concat([data.http.ip.response_body], var.allowed_ip_addresses)
    destination_port_range     = "22"
    destination_address_prefix = "VirtualNetwork"
  }
}

resource "azurerm_subnet_network_security_group_association" "packer_build_subnet_nsg" {
  subnet_id                 = azurerm_subnet.packer_build_subnet.id
  network_security_group_id = azurerm_network_security_group.packer_build_subnet_nsg.id
}