# Resource Groups 
output "packer_artifacts_resource_group" {
  value = azurerm_resource_group.packer_artifacts_resource_group.name
}

output "packer_build_resource_group" {
  value = azurerm_resource_group.packer_build_resource_group.name
}

output "packer_key_vault_resource_group" {
  value = azurerm_resource_group.packer_key_vault_resource_group.name
}

output "packer_shared_image_gallery_resource_group" {
  value = azurerm_resource_group.packer_shared_image_gallery_resource_group.name
}

# Application
output "packer_client_id" {
  value     = try(azuread_application.packer.application_id, "")
  sensitive = true
}

output "packer_client_secret" {
  value     = try(azuread_service_principal_password.packer.value, "")
  sensitive = true
}

output "packer_subscription_id" {
  value     = data.azurerm_subscription.subscription.subscription_id
  sensitive = true
}

output "packer_tenant_id" {
  value     = data.azurerm_subscription.subscription.tenant_id
  sensitive = true
}

# Key Vault
output "packer_key_vault" {
  value = azurerm_key_vault.packer_key_vault.name
}

# Network 
output "packer_build_vnet" {
  value = azurerm_virtual_network.packer_build_vnet.name
}

output "packer_build_vnet_address_space" {
  value = azurerm_virtual_network.packer_build_vnet.address_space
}

output "packer_build_subnet" {
  value = azurerm_subnet.packer_build_subnet.name
}

output "packer_build_subnet_address_space" {
  value = azurerm_subnet.packer_build_subnet.address_prefixes
}

output "packer_build_subnet_nsg" {
  value = azurerm_network_security_group.packer_build_subnet_nsg.name
}

# Shared Image Gallery 
output "packer_shared_image_gallery" {
  value = azurerm_shared_image_gallery.packer_shared_image_gallery.name
}

output "centos_image_definition" {
  value = azurerm_shared_image.centos_image_definition.name
}


