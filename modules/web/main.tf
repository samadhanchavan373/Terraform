resource "azurerm_service_plan" "serviceplan" {
  for_each            = var.web-environment
  name                = each.key
  location            = each.value.serviceplan_plan_location
  resource_group_name = var.resource_grp_name
  os_type             = each.value.serviceplan_plan_os_type
  sku_name            = each.value.serviceplan_plan_sku
}

resource "azurerm_windows_web_app" "web-app" {
  for_each            = var.web-environment
  name                = each.value.webapp_name
  location            = each.value.serviceplan_plan_location
  resource_group_name = var.resource_grp_name
  service_plan_id     = azurerm_service_plan.serviceplan[each.key].id

  site_config {
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = "v8.0"
    }

  }

  logs {
    detailed_error_messages = false
    failed_request_tracing  = false
  }
}
