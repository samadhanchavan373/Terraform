provider "azurerm" {
  features {}
   client_id = "090e884a-d460-47db-9cc2-7556c3df64d1"
  client_secret = ""
  tenant_id = "d4f4c1e6-b689-400c-bd50-f72517748f44"
  subscription_id = "2829a2c8-e971-4097-a3eb-91ee1afb973f"
}

resource "azurerm_resource_group" "appgrp" {
  name     = "app-grp"
  location = local.resource_group_location
}

resource "azurerm_virtual_network" "app-network" {
  name                = var.app-environment["dev"].virtual_network_name
  location            = local.virtual_network_location
  resource_group_name = azurerm_resource_group.appgrp.name
  address_space       = [var.app-environment["dev"].virtual_network_cidrblock]
}

resource "azurerm_subnet" "app-network-subnets" {
  for_each             = var.app-environment["dev"].subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.appgrp.name
  virtual_network_name = azurerm_virtual_network.app-network.name
  address_prefixes     = [each.value.cidrblock]
}

resource "azurerm_network_interface" "app-nics" {
  for_each            = var.app-environment["dev"].subnets.websubnet1.machines
  name                = each.value.nic_name
  location            = local.virtual_network_location
  resource_group_name = azurerm_resource_group.appgrp.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.app-network-subnets["websubnet1"].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web-pip[each.key].id
  }
  depends_on = [azurerm_subnet.app-network-subnets]
}

resource "azurerm_network_interface" "app-nics2" {
  for_each            = var.app-environment["dev"].subnets.websubnet2.machines
  name                = each.value.nic_name
  location            = local.virtual_network_location
  resource_group_name = azurerm_resource_group.appgrp.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.app-network-subnets["websubnet2"].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web-pip2[each.key].id
  }
  depends_on = [azurerm_subnet.app-network-subnets]
}

resource "azurerm_public_ip" "web-pip" {
  for_each            = var.app-environment["dev"].subnets.websubnet1.machines
  name                = each.value.Public_ip_name
  location            = local.virtual_network_location
  resource_group_name = azurerm_resource_group.appgrp.name
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "web-pip2" {
  for_each            = var.app-environment["dev"].subnets.websubnet2.machines
  name                = each.value.Public_ip_name
  location            = local.virtual_network_location
  resource_group_name = azurerm_resource_group.appgrp.name
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "app-nsg" {
  name                = "samadhanappnsg"
  location            = local.virtual_network_location
  resource_group_name = azurerm_resource_group.appgrp.name

  dynamic "security_rule" {
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

resource "azurerm_subnet_network_security_group_association" "websubnet1-nsg-associations" {
  for_each                  = azurerm_subnet.app-network-subnets
  subnet_id                 = azurerm_subnet.app-network-subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.app-nsg.id
  depends_on                = [azurerm_network_security_group.app-nsg]
}

resource "azurerm_windows_virtual_machine" "webvms" {
  for_each            = var.app-environment["dev"].subnets.websubnet1.machines
  name                = each.key
  resource_group_name = azurerm_resource_group.appgrp.name
  location            = local.virtual_network_location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = azurerm_key_vault_secret.vmpassword.value
  network_interface_ids = [
    azurerm_network_interface.app-nics[each.key].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "linuxvm" {
  for_each            = var.app-environment["dev"].subnets.websubnet2.machines
  name                = each.key
  resource_group_name = azurerm_resource_group.appgrp.name
  location            = local.virtual_network_location
  size                = var.vm_size
  admin_username      = var.admin_username
  disable_password_authentication = false
  admin_password      = azurerm_key_vault_secret.vmpassword.value
  custom_data        = filebase64("cloudinit.config") // or data.local_file.cloudinit.content_base64
  network_interface_ids = [
    azurerm_network_interface.app-nics2[each.key].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
