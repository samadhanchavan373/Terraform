/*resource "azurerm_storage_account" "stacc"{
  name = "samdhanstorageaccount"
  location = local.resource_grp_location
  resource_group_name = azurerm_resource_group.app-rg.name
  account_kind = "StorageV2"
  account_tier = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "logcontainer"{
  name = "webapplogs"
  storage_account_name =   azurerm_storage_account.stacc.name
  container_access_type = "blob"
}

data "azurerm_storage_account_blob_container_sas" "accountsas"{
    connection_string = azurerm_storage_account.stacc.primary_connection_string
    container_name = azurerm_storage_container.logcontainer.name
    https_only = true
    
    start = "2026-07-20"
    expiry = "2026-07-22"
   
   permissions{
    read = true
    add = true
    create = true
    write = true
    delete = true
    list = true
   }
}*/