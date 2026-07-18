resource "azurerm_storage_account" "app-storage" {
  name                     = "appsamstorageaccount"
  resource_group_name      = azurerm_resource_group.appgrp.name
  location                 = local.virtual_network_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}

resource "azurerm_storage_container" "app-storage-container" {
  name                  = "testcontainer"
  storage_account_name  = azurerm_storage_account.app-storage.name
  container_access_type = "blob"
}


resource "azurerm_storage_blob" "app-storage-container-blob" {
  name                   = "IIS.ps1"
  storage_account_name   = azurerm_storage_account.app-storage.name
  storage_container_name = azurerm_storage_container.app-storage-container.name
  type                   = "Block"
  source                 = "IIS.ps1"
}


resource "azurerm_virtual_machine_extension" "vmextension" {
  for_each            = var.app-environment["dev"].subnets.websubnet1.machines
  name                 = each.key
  virtual_machine_id   = azurerm_windows_virtual_machine.webvms["appvm1"].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
    {
        "fileUris": ["https://${azurerm_storage_account.app-storage.name}.blob.core.windows.net/${azurerm_storage_container.app-storage-container.name}/${azurerm_storage_blob.app-storage-container-blob.name}"],
        "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File ${azurerm_storage_blob.app-storage-container-blob.source}"
    }
SETTINGS
}