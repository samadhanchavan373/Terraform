variable "resource_grp_name" {
  description = "Name of the resource group"
  type        = string
}

variable "resource_grp_location" {
  description = "Location of the resource group"
  type        = string
}


variable "virtual_network_subnet_id" {
  description = "ID of the virtual network subnet"
  type        = list(string)
}

variable "backend_address_pool_id" {
  description = "ID of the backend address pool"
  type        = string
}