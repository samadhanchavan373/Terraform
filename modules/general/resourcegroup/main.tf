resource "azurerm_resource_group" "app-rg" {
  name = var.resource_grp_name
  location = var.resource_grp_location
}
