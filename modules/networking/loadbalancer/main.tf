resource "azurerm_public_ip" "load-balance-public-ipaddress" {
  name                = "load-bal-pip"
  location            = var.resource_grp_location
  resource_group_name = var.resource_grp_name
  allocation_method   = "Static"
  sku                = "Standard"
}

resource "azurerm_lb" "load-balancer" {
  name                = "app-balancer"
  location            = var.resource_grp_location
  resource_group_name = var.resource_grp_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "load-balancer-frontend"
    public_ip_address_id = azurerm_public_ip.load-balance-public-ipaddress.id
  }
}

resource "azurerm_lb_backend_address_pool" "load-balancer-backend-pool" {
  name                = "load-balancer-backend-pool"
  loadbalancer_id     = azurerm_lb.load-balancer.id
}

/*resource "azurerm_lb_backned_address_pool_address" "load-balancer-backend-address" {
  count               = var.virtual_machine_count
  name                = "load-balancer-backend-address-${count.index + 1}"
  resource_group_name = var.resource_grp_name
  loadbalancer_id     = azurerm_lb.load-balancer.id
  backend_address_pool_id = azurerm_lb_backend_address_pool.load-balancer-backend-pool.id
  ip_address          = var.virtual_machines_ip_addresses[count.index]
}*/

resource "azurerm_lb_backend_address_pool_address" "load-balancer-backend-address" {
  count               = var.virtual_machine_count
  name                = "load-balancer-backend-address-${count.index + 1}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.load-balancer-backend-pool.id
  ip_address          = var.network_interface_private_ip_addresses[count.index]
  virtual_network_id = var.virtual_network_id
}


resource "azurerm_lb_probe" "load-balancer-probe" {
  name                = "load-balancer-probe"
  loadbalancer_id     = azurerm_lb.load-balancer.id
  protocol            = "Tcp"
  port                = 80
}

resource "azurerm_lb_rule" "load-balancer-rule" {
  name                           = "load-balancer-rule"
  loadbalancer_id                = azurerm_lb.load-balancer.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name =  "load-balancer-frontend"
  backend_address_pool_ids        = [azurerm_lb_backend_address_pool.load-balancer-backend-pool.id]
  probe_id                       = azurerm_lb_probe.load-balancer-probe.id
}