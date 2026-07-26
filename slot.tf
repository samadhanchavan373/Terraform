/*resource "azurerm_windows_web_app_slot" "stagingslot" {
  name = var.webapp-slots[1]
  app_service_id = azurerm_windows_web_app.webapp[var.webapp-slots[0]].id

  lifecycle {
    ignore_changes = [logs]
  }

  site_config {
   application_stack {
     current_stack = "dotnet"
     dotnet_version = "v8.0"
   }
  }
  depends_on = [ azurerm_service_plan.serviceplan ]
}*/