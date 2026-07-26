resource "azurerm_network_interface" "dbnic-nics" {
  for_each            = var.app-environment["production"].subnets["dbsubnet01"].machines
  name                = each.value.nic_name
  location            = local.resource_grp_location
  resource_group_name = azurerm_resource_group.app-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.app-network-subnets["dbsubnet01"].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web-pip[each.key].id
  }
  depends_on = [azurerm_subnet.app-network-subnets]
}


resource "azurerm_public_ip" "web-pip" {
  for_each            = var.app-environment["production"].subnets["dbsubnet01"].machines
  name                = each.value.Public_ip_name
  location            = local.resource_grp_location
  resource_group_name = azurerm_resource_group.app-rg.name
  allocation_method   = "Static"
}


resource "azurerm_linux_virtual_machine" "linuxvm" {
  for_each            = var.app-environment["production"].subnets["dbsubnet01"].machines
  name                = each.key
  resource_group_name = azurerm_resource_group.app-rg.name
  location            = local.resource_grp_location
  size                = var.vm_size
  admin_username      = "linuxadmin"
  disable_password_authentication = false
  admin_password      = var.admin_password
  custom_data        = filebase64("cloudinit.config") // or data.local_file.cloudinit.content_base64
  network_interface_ids = [
    azurerm_network_interface.dbnic-nics[each.key].id,
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