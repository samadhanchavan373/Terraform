resource "azurerm_subnet" "Bastion-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.appgrp.name
  virtual_network_name = var.app-environment["dev"].virtual_network_name
  address_prefixes     = ["10.0.1.0/26"]
}

resource "azurerm_public_ip" "bastion-pip" {
  name                = "bastion-ip"
  location            = local.virtual_network_location
  resource_group_name = azurerm_resource_group.appgrp.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion-host" {
  name                = "bastion-host"
  location            = local.virtual_network_location
  resource_group_name = azurerm_resource_group.appgrp.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.Bastion-subnet.id
    public_ip_address_id = azurerm_public_ip.bastion-pip.id
  }
}