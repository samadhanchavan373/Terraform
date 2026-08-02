resource "azurerm_linux_virtual_machine_scale_set" "vm-scale-set" {
  name                = "app-linux-vmss"
  location            = var.resource_grp_location
  resource_group_name = var.resource_grp_name
  sku                 = "Standard_B2as_v2"
  instances           = 2
  admin_username      = "linuxadmin"
  admin_password      = "testTEST@1234"
   disable_password_authentication = false
  custom_data        =  data.local_file.cloudinit.content_base64

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  network_interface {
    name    = "app-vmss-nic"
    primary = true

    ip_configuration {
      name      = "app-vmss-ipconfig"
      subnet_id = var.virtual_network_subnet_id[0]
      primary   = true
      load_balancer_backend_address_pool_ids = [var.backend_address_pool_id]
    }
  }
}

data "local_file" "cloudinit" {
    filename = "./modules/compute/scalesets/cloudinit"
  }