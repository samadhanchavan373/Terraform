resource_grp_name = "app-grp-lb"
resource_grp_location = "North Europe"

web-environment = {
      "central-India-app-service-plan" = {
        serviceplan_plan_os_type = "Windows"
        serviceplan_plan_sku = "S1"
        serviceplan_plan_location = "Central India"
        webapp_name = "central-India-app-service-samadhan"
      },
     "North-Europe-app-service-plan" = {
        serviceplan_plan_os_type = "Windows"
        serviceplan_plan_sku = "S1"
        serviceplan_plan_location = "North Europe"
        webapp_name = "North-Europe-app-service-samadhan"
      }
    }

 traffic-manager-endpoints = {
  "primary-endpoint" = {
    endpoint_priority = "1"
    endpoint_weight = "100"
    endpoint_target_resource_id = "azurerm_public_ip.example.id"
  }
  "secondary-endpoint" = {
    endpoint_priority = "2"
    endpoint_weight = "100"
    endpoint_target_resource_id = "azurerm_public_ip.example.id"
  }
 }
