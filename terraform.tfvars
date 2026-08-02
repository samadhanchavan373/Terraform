resource_grp_name = "app-grp-lb"
resource_grp_location = "Central India"

vnet_name = "app-network"
vnet_address_prefix = "10.0.0.0/16"
vnet_subnet_count = 2
public-ip-count = 2
network-interfaces-count = 2

network_security_group_rules = [
  {
    priority               = 100
    destination_port_range = "22"
  },
  {
    priority               = 200
    destination_port_range = "80"
  }
]

virtual_machine_count = 2