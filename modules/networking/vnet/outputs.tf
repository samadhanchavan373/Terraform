output "virtual_network_interfaces_ids" {
  value = azurerm_network_interface.network-interfaces[*].id
}

output "public_ip_addresses" {
  value = azurerm_public_ip.public-ipaddress[*].ip_address
}

output "virtual_network_id" {
  value = azurerm_virtual_network.virtual-network.id
}

output "network_interface_private_ip_addresses" {
  value = azurerm_network_interface.network-interfaces[*].private_ip_address
}