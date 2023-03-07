resource "azurerm_key_vault" "packer_key_vault" {
  name                        = var.packer_key_vault
  location                    = azurerm_resource_group.packer_key_vault_resource_group.location
  resource_group_name         = azurerm_resource_group.packer_key_vault_resource_group.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  # network_acls {
  #   bypass         = "AzureServices"
  #   default_action = "Deny"
  #   ip_rules       = var.allowed_ip_address
  # }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Backup",
      "Delete",
      "Get",
      "List",
      "Recover",
      "Restore",
      "Set",
      "Purge"
    ]
  }
}

resource "null_resource" "previous" {}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [null_resource.previous]

  create_duration = "20s"
}

resource "azurerm_key_vault_secret" "packer_client_id" {
  name         = "packer-client-id"
  value        = azuread_application.packer.application_id
  key_vault_id = azurerm_key_vault.packer_key_vault.id
  depends_on   = [time_sleep.wait_30_seconds]
}

resource "azurerm_key_vault_secret" "packer_client_secret" {
  name         = "packer-client-secret"
  value        = azuread_service_principal_password.packer.value
  key_vault_id = azurerm_key_vault.packer_key_vault.id
  depends_on   = [time_sleep.wait_30_seconds]
}

resource "azurerm_key_vault_secret" "packer_subscription_id" {
  name         = "packer-subscription-id"
  value        = data.azurerm_client_config.current.subscription_id
  key_vault_id = azurerm_key_vault.packer_key_vault.id
  depends_on   = [time_sleep.wait_30_seconds]
}

resource "azurerm_key_vault_secret" "packer_tenant_id" {
  name         = "packer-tenant-id"
  value        = data.azurerm_client_config.current.tenant_id
  key_vault_id = azurerm_key_vault.packer_key_vault.id
  depends_on   = [time_sleep.wait_30_seconds]
}
