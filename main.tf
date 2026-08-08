
module "resource-group" {
  source                = "./modules/general/resourcegroup"
  resource_grp_name     = var.resource_grp_name
  resource_grp_location = var.resource_grp_location
}

module "web-app" {
  source            = "./modules/web"
  resource_grp_name = module.resource-group.resource_group_name
  web-environment   = var.web-environment
}

module "traffic-manager" {
  source                     = "./modules/networking/trafficmanager"
  resource_grp_name          = module.resource-group.resource_group_name
  resource_grp_location      = var.resource_grp_location
  traffic-manager-endpoints  = var.traffic-manager-endpoints
  webapp-ids                 = module.web-app.webapp-ids
  webapp-hostnames           = module.web-app.webapp-hostnames
  secondary-app-service-name = module.web-app.secondary-app-service-name
}

output "web-app-ids" {
  value = module.web-app.webapp-ids
}

output "weba-app-hostnames" {
  value = module.web-app.webapp-hostnames
}
