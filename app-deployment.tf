/*resource "azurerm_service_plan" "serviceplan" {
  for_each = var.web-environment.production.serviceplan
  name = each.key
  location = local.resource_grp_location
  resource_group_name = azurerm_resource_group.app-rg.name
  os_type = each.value.os_type
  sku_name = each.value.sku
}

resource "azurerm_windows_web_app" "web-app"{
    for_each = var.web-environment.production.serviceapp
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
    name = "AZURE_SQL_CONNECTIONSTRING"
    type = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.sqlserver[var.app-setup[0]].fully_qualified_domain_name},1433;Initial Catalog=${var.app-setup[1]};User Id=${azurerm_mssql_server.sqlserver[var.app-setup[0]].administrator_login};Password='${azurerm_mssql_server.sqlserver[var.app-setup[0]].administrator_login_password}';"
    }
}

resource "azurerm_mssql_firewall_rule" "allowazureservices"{
    name = "allowazureservices"
  server_id = azurerm_mssql_server.sqlserver[var.app-setup[0]].id
  start_ip_address = "0.0.0.0"
  end_ip_address = "0.0.0.0"
}

resource "azurerm_app_service_source_control" "app-service-source-control" {
  app_id = azurerm_windows_web_app.web-app["samadhanwebapp"].id
  repo_url = "https://github.com/samadhanchavan373/Terraformwebapp"
  branch = "master"
  use_manual_integration = true
}*/