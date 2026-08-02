variable "resource_grp_name" {
  description = "Name of the resource group"
  type        = string
}

variable "resource_grp_location" {
  description = "Location of the resource group"
  type        = string
}

variable "virtual_machine_count" {
  description = "Number of virtual machines to create"
  type        = number
}


variable "network_interface_private_ip_addresses" {
  description = "Private IP addresses of the network interfaces"
    type        = list(string)
}

variable "virtual_network_id" {
  description = "ID of the virtual network"
  type        = string
}