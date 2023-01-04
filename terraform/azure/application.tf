resource "azuread_application" "packer" {
  display_name = var.packer_azuread_application
}

resource "azuread_service_principal" "packer" {
  application_id = azuread_application.packer.application_id
}

resource "azuread_service_principal_password" "packer" {
  service_principal_id = azuread_service_principal.packer.id
}

resource "azurerm_role_assignment" "subscription_reader" {
  scope                = data.azurerm_subscription.subscription.id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.packer.id
}

resource "azurerm_role_assignment" "packer_build_contributor" {
  scope                = azurerm_resource_group.packer_build_resource_group.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.packer.id
}

resource "azurerm_role_assignment" "packer_artifacts_contributor" {
  scope                = azurerm_resource_group.packer_artifacts_resource_group.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.packer.id
}

resource "azurerm_role_assignment" "packer_shared_image_gallery_contributor" {
  scope                = azurerm_resource_group.packer_shared_image_gallery_resource_group.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.packer.id
}

resource "azurerm_role_definition" "delete_image_versions" {
  name  = "image-version-delete-role"
  scope = data.azurerm_subscription.subscription.id

  permissions {
    actions     = ["Microsoft.Compute/galleries/images/versions/delete"]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.subscription.id,
  ]
}

resource "azurerm_role_assignment" "delete_image_versions" {
  scope              = data.azurerm_subscription.subscription.id
  role_definition_id = azurerm_role_definition.delete_image_versions.role_definition_resource_id
  principal_id       = azuread_service_principal.packer.id
}