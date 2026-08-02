variable "resource_grp_name" {
  description = "Name of the resource group"
  type        = string
}

variable "resource_grp_location" {
  description = "Location of the resource group"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "vnet_address_prefix" {
  description = "Address prefix for the virtual network"
  type        = string
}

variable "vnet_subnet_count" {
  description = "Number of subnets for the virtual network"
  type        = number
}


variable "public-ip-count" {
  description = "Number of public IPs to create"
  type        = number
}

variable "network-interfaces-count" {
  description = "Number of network interfaces to create"
  type        = number
}

variable "network_security_group_rules" {
  description = "List of security rules for the network security group"
  type = list(object({
    priority               = number
    destination_port_range = string
  }))
}