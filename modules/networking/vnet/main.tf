resource "azurerm_virtual_network" "virtual-network" {
  name                = var.vnet_name
  location            = var.resource_grp_location
  resource_group_name = var.resource_grp_name
  address_space       = [var.vnet_address_prefix]
}


resource "azurerm_subnet" "network-subnets" {
  count = var.vnet_subnet_count
  name                 = "subnet-${count.index + 1}"
  resource_group_name  = var.resource_grp_name
  virtual_network_name = azurerm_virtual_network.virtual-network.name
  address_prefixes     = [cidrsubnet(var.vnet_address_prefix, 8, count.index)]
}

resource "azurerm_public_ip" "public-ipaddress" {
  count              = var.public-ip-count
  name                = "pip-${count.index + 1}"
  location            = var.resource_grp_location
  resource_group_name = var.resource_grp_name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "network-interfaces" {
  count = var.network-interfaces-count
  name                = "nic-${count.index + 1}"
  location            = var.resource_grp_location
  resource_group_name = var.resource_grp_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.network-subnets[count.index].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public-ipaddress[count.index].id
  }
  depends_on = [azurerm_subnet.network-subnets, azurerm_public_ip.public-ipaddress]
}

resource "azurerm_network_security_group" "network-security-group" {
  name                = "network-nsg"
  location            = var.resource_grp_location
  resource_group_name = var.resource_grp_name

  dynamic security_rule {
    for_each = toset(var.network_security_group_rules)
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

resource "azurerm_subnet_network_security_group_association" "subnet-nsg-associations" {
  count = var.vnet_subnet_count
  subnet_id                 = azurerm_subnet.network-subnets[count.index].id
  network_security_group_id = azurerm_network_security_group.network-security-group.id
}
