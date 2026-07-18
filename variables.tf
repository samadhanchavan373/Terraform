/*variable "vmname"{
 type = string
 description = "Name of the virtual machine"
}





*/

variable "admin_username" {
  type        = string
  description = "Username for the administrator account"
}

variable "admin_password" {
  type        = string
  description = "Password for the administrator account"
  sensitive   = true
}

variable "vm_size" {
  type        = string
  description = "Size of the virtual machine"
  default     = "Standard_B2as_v2"
}

/*variable "network_interface_count" {
  type        = number
  description = "Number of network interfaces to create"
}*/



variable "app-environment" {
  type = map(object(
    {
      virtual_network_name      = string
      virtual_network_cidrblock = string
      subnets = map(object(
        {
          cidrblock = string
          machines = map(object(
            {
              nic_name       = string
              Public_ip_name = string
          }))
      }))
  }))
}