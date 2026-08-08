resource "azurerm_traffic_manager_profile" "traffic-mnager-profile" {
  name                   = "traffic-manager-profile-samadhan"
  resource_group_name    = var.resource_grp_name
  traffic_routing_method = "Performance"

  dns_config {
    relative_name = "traffic-manager-profile-samadhan"
    ttl           = 100
  }

  monitor_config {
    protocol                     = "HTTPS"
    port                         = 80
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }
}

resource "azurerm_traffic_manager_azure_endpoint" "example" {
  for_each             = var.traffic-manager-endpoints
  name                 = each.key
  profile_id           = azurerm_traffic_manager_profile.traffic-mnager-profile.id
  always_serve_enabled = true
  weight               = each.value.endpoint_weight
  priority             = each.value.endpoint_priority
  target_resource_id = var.webapp-ids[each.value.endpoint_priority - 1] #hack to get the target resource id from the webapp-ids list

  custom_header {
    name  = "host"
    value = var.webapp-hostnames[each.value.endpoint_priority - 1]
  }

  depends_on = [azurerm_traffic_manager_profile.traffic-mnager-profile]
}

/*
resource "azurerm_app_service_custom_hostname_binding" "secondary-app-service-binding" {
  hostname            = azurerm_traffic_manager_profile.traffic-mnager-profile.fqdn
  app_service_name    = var.secondary-app-service-name
  resource_group_name = var.resource_grp_name
  depends_on          = [azurerm_traffic_manager_azure_endpoint.example]
}*/
