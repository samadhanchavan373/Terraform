


# provider "azurerm" {
#   features {}
#   subscription_id = "2829a2c8-e971-4097-a3eb-91ee1afb973f"
# }

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

# resource "azurerm_storage_account" "app-storage" {
#   name                     = "appsamstorageaccount"
#   resource_group_name      =azurerm_resource_group.appgrp.name
#   location                 = "North Europe"
#   account_tier             = "Standard"
#   account_replication_type = "LRS"

#   tags = {
#     environment = "myappaccount"
#   }
# }

# resource "azurerm_storage_container" "app-storage-container" {
#   name                  = "testcontainer"
#   storage_account_name = azurerm_storage_account.app-storage.name
# }

# resource "azurerm_storage_blob" "app-storage-container-blob" {
#   name                 = "testblob.txt"
#   storage_account_name = azurerm_storage_account.app-storage.name
#   storage_container_name = azurerm_storage_container.app-storage-container.name
#   type                 = "Block"
#   source               = "testblob.txt"
#   depends_on = [azurerm_storage_container.app-storage-container]
# }



resource "azurerm_virtual_network" "app-network" {
  name                = local.virtual_network_address_prefix.name
  location            = local.virtual_network_location
  resource_group_name = azurerm_resource_group.appgrp.name
  address_space       = local.virtual_network_address_prefix.address_prefixes
}


resource "azurerm_subnet" "websubnet1" {
  name                 = local.subnet_list[0].name
  resource_group_name  = azurerm_resource_group.appgrp.name
  virtual_network_name = azurerm_virtual_network.app-network.name
  address_prefixes     = [local.subnet_list[0].address_prefixes]

}


resource "azurerm_subnet" "websubnet2" {
  name                 = local.subnet_list[1].name
  resource_group_name  = azurerm_resource_group.appgrp.name
  virtual_network_name = azurerm_virtual_network.app-network.name
  address_prefixes     = [local.subnet_list[1].address_prefixes]

}

resource "azurerm_network_interface" "app-nic1" {
  name                = "app-nic1"
  location            = local.virtual_network_location
  resource_group_name = azurerm_resource_group.appgrp.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.websubnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web-pip.id
  }
  depends_on = [ azurerm_subnet.websubnet1 , azurerm_public_ip.web-pip]
}

resource "azurerm_network_interface" "app-nic2" {
  name                = "app-nic2"
  location            = local.virtual_network_location
  resource_group_name = azurerm_resource_group.appgrp.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.websubnet2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web-pip1.id
  }

  depends_on = [azurerm_subnet.websubnet2, azurerm_public_ip.web-pip1]
}

# output "websubnet1_id" {
#   value = azurerm_subnet.websubnet1
# }

resource "azurerm_public_ip" "web-pip" {
  name                    = "web-pip"
  location                = local.virtual_network_location
  resource_group_name     = azurerm_resource_group.appgrp.name
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30
  depends_on = [azurerm_virtual_network.app-network]
}

resource "azurerm_public_ip" "web-pip1" {
  name                    = "web-pip1"
  location                = local.virtual_network_location
  resource_group_name     = azurerm_resource_group.appgrp.name
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30
  depends_on = [azurerm_virtual_network.app-network]
}


resource "azurerm_network_security_group" "app-nsg" {
  name                = "samadhanappnsg"
  location            = local.virtual_network_location
  resource_group_name = azurerm_resource_group.appgrp.name

  security_rule {
    name                       = "AllowRDP"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3380"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "websubnet1-nsg-association" {
  subnet_id                 = azurerm_subnet.websubnet1.id
  network_security_group_id = azurerm_network_security_group.app-nsg.id
  depends_on = [azurerm_network_security_group.app-nsg, azurerm_subnet.websubnet1]
}

resource "azurerm_subnet_network_security_group_association" "websubnet2-nsg-association" {
  subnet_id                 = azurerm_subnet.websubnet2.id
  network_security_group_id = azurerm_network_security_group.app-nsg.id
  depends_on = [azurerm_network_security_group.app-nsg, azurerm_subnet.websubnet2]
}


resource "azurerm_windows_virtual_machine" "webvm" {
  name                = var.vmname
  resource_group_name = azurerm_resource_group.appgrp.name
  location            = local.virtual_network_location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.app-nic1.id,
    azurerm_network_interface.app-nic2.id,
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


resource "azurerm_managed_disk" "vm_managed_disk" {
  name                 = "vm_managed_disk"
  location             = local.virtual_network_location
  resource_group_name  = azurerm_resource_group.appgrp.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "4"
}

resource "azurerm_virtual_machine_data_disk_attachment" "vm-disk-attachment" {
  managed_disk_id    = azurerm_managed_disk.vm_managed_disk.id
  virtual_machine_id = azurerm_windows_virtual_machine.webvm.id
  lun                = "0"
  caching            = "ReadWrite"
  depends_on = [azurerm_windows_virtual_machine.webvm, azurerm_managed_disk.vm_managed_disk]
}