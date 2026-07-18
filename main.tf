


# provider "azurerm" {
#   features {}
#   subscription_id = "2829a2c8-e971-4097-a3eb-91ee1afb973f"
# }
/*
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
}*/

/*
 resource "azurerm_storage_account" "app-storage" {
  count                    = 3
  name                     = "appsamstorageaccount${count.index + 1}"
  resource_group_name      =azurerm_resource_group.appgrp.name
  location                 = "North Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
 }

 resource "azurerm_storage_container" "app-storage-container" {
  count                = 3
   name                  = "testcontainer${count.index + 1}"
   storage_account_name = azurerm_storage_account.app-storage[0].name
 }

 output "container-names" {
  value = azurerm_storage_container.app-storage-container[*].name
  description = "The names of the created storage containers"
 }

  resource "azurerm_storage_container" "app-storage-container-using-for-each" {
   for_each = toset(["scripts", "images", "videos"])
   name                  = each.key
   storage_account_name = azurerm_storage_account.app-storage[0].name
 }

 output "container-names1" {
  value = [for container in azurerm_storage_container.app-storage-container-using-for-each : container.name]
  description = "The names of the created storage containers"
 }

 resource "azurerm_storage_blob" "app-storage-container-blob" {
  for_each = tomap({
    "blob1" = "blob1.txt",
    "blob2"  = "blob2.txt",
    "blob3"  = "blob3.txt"})
   name                 = each.value
   storage_account_name = azurerm_storage_account.app-storage[0].name
   storage_container_name = azurerm_storage_container.app-storage-container-using-for-each["scripts"].name
   type                 = "Block"
   source               = each.value
}*/


/*
resource "azurerm_virtual_network" "app-network" {
  name                = var.app-environment["dev"].virtual_network_name
  location            = local.virtual_network_location
  resource_group_name = azurerm_resource_group.appgrp.name
  address_space       = [var.app-environment["dev"].virtual_network_cidrblock]
}


resource "azurerm_subnet" "app-network-subnets" {
  for_each = var.app-environment["dev"].subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.appgrp.name
  virtual_network_name = azurerm_virtual_network.app-network.name
  address_prefixes     = [each.value.cidrblock]

}


resource "azurerm_network_interface" "app-nics" {
  name                = var.app-environment["dev"].nic_name
  location            = local.virtual_network_location
  resource_group_name = azurerm_resource_group.appgrp.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.app-network-subnets["websubnet1"].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web-pip.id
  }
  depends_on = [ azurerm_subnet.app-network-subnets]
}



resource "azurerm_public_ip" "web-pip" {
  name                    = var.app-environment["dev"].Public_ip_name
  location                = local.virtual_network_location
  resource_group_name     = azurerm_resource_group.appgrp.name
  allocation_method       = "Static"
}


resource "azurerm_network_security_group" "app-nsg" {
  name                = "samadhanappnsg"
  location            = local.virtual_network_location
  resource_group_name = azurerm_resource_group.appgrp.name

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


resource "azurerm_subnet_network_security_group_association" "websubnet1-nsg-associations" {

  for_each = azurerm_subnet.app-network-subnets
  subnet_id                 = azurerm_subnet.app-network-subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.app-nsg.id
  depends_on = [azurerm_network_security_group.app-nsg]
}*/

/*
resource "azurerm_windows_virtual_machine" "webvms" {
  name                = var.app-environment["dev"].vm_name
  resource_group_name = azurerm_resource_group.appgrp.name
  location            = local.virtual_network_location
  size                =var.vm_size
  admin_username      = var.admin_username
  admin_password      = azurerm_key_vault_secret.vmpassword.value
  network_interface_ids = [
    azurerm_network_interface.app-nics.id,
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
*/

# need to perform upgrade bcoz this is local provider not azurerm provider
#
/*
data "local_file" "cloudinit" {
  filename = "${path.module}/cloudinit.config"
}

output "cloudinit" {
  value = data.local_file.cloudinit.content
}
*/