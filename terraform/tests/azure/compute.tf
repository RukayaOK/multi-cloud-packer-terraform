
resource "azurerm_public_ip" "main" {
  name                = var.public_ip_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = var.public_ip_allocation_method
}

#Create Network Card for Web Server VM
resource "azurerm_network_interface" "main" {
  name                = var.nic_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = var.nic_ip_config_name
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = var.nic_ip_config_private_ip_allocation_method
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}


# Create web server vm
resource "azurerm_virtual_machine" "main" {
  name                             = var.vm_name
  location                         = azurerm_resource_group.main.location
  resource_group_name              = azurerm_resource_group.main.name
  network_interface_ids            = [azurerm_network_interface.main.id]
  vm_size                          = var.vm_size
  delete_os_disk_on_termination    = var.delete_os_disk_on_termination
  delete_data_disks_on_termination = var.delete_data_disks_on_termination

  storage_image_reference {
    id = data.azurerm_image.main.id
  }

  storage_os_disk {
    name              = var.storage_os_disk_name
    caching           = var.storage_os_disk_caching
    create_option     = var.storage_os_disk_create_option
    managed_disk_type = var.storage_os_disk_managed_disk_type
  }

  os_profile {
    computer_name  = var.vm_hostname
    admin_username = var.vm_admin_username
    admin_password = var.vm_admin_password
    #custom_data    = file("azure-user-data.sh")
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
