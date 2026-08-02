
module "resource-group" {
  source = "./modules/general/resourcegroup"
  resource_grp_name = var.resource_grp_name
  resource_grp_location = var.resource_grp_location
}

module "network" {
  source = "./modules/networking/vnet"
  resource_grp_name = var.resource_grp_name
  resource_grp_location = var.resource_grp_location
  vnet_name = var.vnet_name
  vnet_address_prefix = var.vnet_address_prefix
  vnet_subnet_count = var.vnet_subnet_count
  network-interfaces-count = var.network-interfaces-count
  public-ip-count = var.public-ip-count
  network_security_group_rules = var.network_security_group_rules
  depends_on = [module.resource-group] #imp
}


module "loadbalancer" {
  source = "./modules/networking/loadbalancer"
  resource_grp_name = var.resource_grp_name
  resource_grp_location = var.resource_grp_location
  virtual_machine_count = var.virtual_machine_count
  virtual_network_id = module.network.virtual_network_id #imp
  network_interface_private_ip_addresses = module.network.network_interface_private_ip_addresses #imp
  depends_on = [module.network] #imp
}

module "virtual-machines-scaleset" {
  source = "./modules/compute/scalesets"
  resource_grp_name = var.resource_grp_name
  resource_grp_location = var.resource_grp_location
  virtual_network_subnet_id = module.network.virtual_network_subnet_id
  backend_address_pool_id = module.loadbalancer.backend_address_pool_id
  depends_on = [module.loadbalancer] #imp
}
