resource "azurerm_virtual_network" "app-network" {
  name                = var.app-environment.production.virtual_network_name
  location            = local.resource_grp_location
  resource_group_name = azurerm_resource_group.app-rg.name
  address_space       = [var.app-environment.production.virtual_network_cidrblock]
}

resource "azurerm_subnet" "app-network-subnets" {
  for_each             = var.app-environment.production.subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.app-rg.name
  virtual_network_name = azurerm_virtual_network.app-network.name
  address_prefixes     = [each.value.cidrblock]
}


resource "azurerm_network_security_group" "app-nsg" {
  name                = "app-nsg"
  location            = local.resource_grp_location
  resource_group_name = azurerm_resource_group.app-rg.name

  dynamic security_rule {
    for_each = local.network_security_group_rules
    content {   
    name                       = "Allow-${security_rule.value.destination_port_range}"
    priority                   = security_rule.value.priority
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = security_rule.value.destination_port_range
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
}

resource "azurerm_subnet_network_security_group_association" "dbsubnet-nsg-associations" {
  subnet_id                 = azurerm_subnet.app-network-subnets["dbsubnet01"].id
  network_security_group_id = azurerm_network_security_group.app-nsg.id
}


resource "azurerm_subnet" "app-subnet01" {
  name                 = "app-subnet01"
  resource_group_name  = azurerm_resource_group.app-rg.name
  virtual_network_name = azurerm_virtual_network.app-network.name
  address_prefixes     = ["10.0.2.0/24"]
  delegation  {
    name = "subnet-delegation"

    service_delegation {
    name = "Microsoft.Web/serverFarms"
    actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
  }
  }
}