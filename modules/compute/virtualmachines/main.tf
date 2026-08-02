resource "azurerm_linux_virtual_machine" "linuxvm" {
  count               = var.virtual_machine_count
  name                = "webvm-${count.index + 1}"
  resource_group_name = var.resource_grp_name
  location            = var.resource_grp_location
  size                = "Standard_B2as_v2"
  admin_username      = "linuxadmin"
  disable_password_authentication = false
  admin_password      = "testTEST@1234"
  custom_data        =  data.local_file.cloudinit.content_base64
  network_interface_ids = [
    var.virtual_network_interfaces_ids[count.index]
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

data "local_file" "cloudinit" {
    filename = "./modules/compute/virtualmachines/cloudinit"
  }