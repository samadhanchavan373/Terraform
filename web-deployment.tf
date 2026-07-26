resource "azurerm_service_plan" "serviceplan" {
  for_each = var.app-environment.production.serviceplan
  name = each.key
  location = local.resource_grp_location
  resource_group_name = azurerm_resource_group.app-rg.name
  os_type = each.value.os_type
  sku_name = each.value.sku
}

resource "azurerm_windows_web_app" "web-app"{
    for_each = var.app-environment.production.serviceapp
  name = each.key
  location = local.resource_grp_location
  resource_group_name = azurerm_resource_group.app-rg.name
  service_plan_id = azurerm_service_plan.serviceplan[each.value].id

  site_config {
    always_on = false

    application_stack {
      current_stack = "dotnet"
      dotnet_version = "v8.0"
    }
    
    }

  connection_string {
    name = "MySQLConnectionString"
    type = "Custom"
    value = "Server=10.0.1.4;userID=appuser;Password=Microsoft@123;Database=appdb"
    }
}



resource "azurerm_app_service_source_control" "app-service-source-control" {
  app_id = azurerm_windows_web_app.web-app["webapp220499"].id
  repo_url = "https://github.com/samadhanchavan373/terrafromwebapp2"
  branch = "main"
  use_manual_integration = true
}


resource "azurerm_app_service_virtual_network_swift_connection" "websubnet_webapp"{
  app_service_id = azurerm_windows_web_app.web-app["webapp220499"].id
  subnet_id = azurerm_subnet.app-subnet01.id

  depends_on = [ azurerm_subnet.app-subnet01,  azurerm_windows_web_app.web-app]
}