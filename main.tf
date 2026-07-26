resource "azurerm_resource_group" "app-rg" {
  name = "app-grp"
  location = local.resource_grp_location
  tags = local.production_tags
}