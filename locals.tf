locals{
  resource_group_location = "North Europe"
  virtual_network_location = "Central India"
  virtual_network_address_prefix={
    name= "app-vnet"
    address_prefixes = ["10.0.0.0/16"]
  }
  subnet_list = [
    {
      name = "websubnet1"
      address_prefixes = "10.0.0.0/24"
    },
    {
      name = "websubnet2"
      address_prefixes = "10.0.2.0/24"
    }
  ]
  }
