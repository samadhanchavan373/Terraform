resource "azurerm_storage_account" "import-storage-account"{
name = "terraformimportsamadhan"
resource_group_name =  azurerm_resource_group.app-rg.name
location = local.resource_grp_location
account_tier = "Standard"
account_replication_type = "LRS"

tags = {tier = "standard"}
}

#fix
import {
    to = azurerm_storage_account.import-storage-account
    id= "/subscriptions/2829a2c8-e971-4097-a3eb-91ee1afb973f/resourceGroups/app-grp/providers/Microsoft.Storage/storageAccounts/terraformimportsamadhan"
}