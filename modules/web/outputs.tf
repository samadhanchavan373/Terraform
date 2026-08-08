output "webapp-ids" {
  value = values(azurerm_windows_web_app.web-app)[*].id #values(azurerm_windows_web_app.webapp) returns a map of webapp names and their ids, [*] returns a list of ids
}
output "webapp-hostnames" {
  value = values(azurerm_windows_web_app.web-app)[*].default_hostname
}

output "secondary-app-service-name" {
  value = azurerm_windows_web_app.web-app["North-Europe-app-service-plan"].name
}

