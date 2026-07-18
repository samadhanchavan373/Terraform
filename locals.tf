locals {
  resource_group_location  = "North Europe"
  virtual_network_location = "Central India"
  virtual_network_address_prefix = {
    name             = "app-vnet"
    address_prefixes = ["10.0.0.0/16"]
  }
  subnet_list = [
    {
      name             = "websubnet1"
      address_prefixes = ["10.0.0.0/24"]
    },
    {
      name             = "websubnet2"
      address_prefixes = ["10.0.2.0/24"]
    }
  ]

  network_security_group_rules = [
    {
      priority               = 301
      destination_port_range = "3389"

    },
    {
      priority               = 303
      destination_port_range = "80"
    },
    {
      priority               = 304
      destination_port_range = "22"
    }
  ]

  linux_vm_size = "B2s_v2"
}

