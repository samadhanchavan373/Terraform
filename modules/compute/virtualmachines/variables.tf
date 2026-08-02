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

variable "virtual_network_interfaces_ids" {
  description = "IDs of the virtual network interfaces"
  type        = list(string)
}

variable "virtual_machines_ip_addresses" {
  description = "IP addresses of the virtual machines"
  type        = list(string)
}
