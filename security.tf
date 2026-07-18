resource "azurerm_key_vault" "kv" {
  name                = "kv-demo-samadhan-01" # must be globally unique
  location            = local.virtual_network_location
  resource_group_name = azurerm_resource_group.appgrp.name
  tenant_id           = "d4f4c1e6-b689-400c-bd50-f72517748f44"
  sku_name            = "standard"

  # This is the key setting - switches from access policies to Azure RBAC
  enable_rbac_authorization = true

  purge_protection_enabled   = false
  soft_delete_retention_days = 7
}

resource "azurerm_role_assignment" "kv_secrets_officer" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = "c05af488-b2d4-41b9-9ac3-267c97c4b085"
}

resource "time_sleep" "rbac_propagation" {
  depends_on      = [azurerm_role_assignment.kv_secrets_officer]
  create_duration = "60s"
}

resource "azurerm_key_vault_secret" "vmpassword" {
  name         = "vmpassword"
  value        = var.admin_password
  key_vault_id = azurerm_key_vault.kv.id
  depends_on   = [time_sleep.rbac_propagation]
}