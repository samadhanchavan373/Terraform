variable "webapp-environment" {
  type = map(object(
    {
      serviceplan = map(object(
        {
            sku = string
            os = string
        }
      ))
      serviceapp = map(string)
    }
  ))
}

variable "tags" {
  type = map(object(
    {
      department = string
      contact = string
    }
  ))
}

variable "webapp-slots"{
  type = list(string)
}



variable "db_app_environemnt" {
  type = map(object({
     server = map(object({
      databases = map(object(
        {
           sku = string
           sampledb = string
        }))
     }))
  }))
}

variable "app-setup" {
  type = list(string)
}



variable "web-environment"{
  type = map(object({

    serviceplan = map(object({
      sku = string
      os_type = string
    }))
    serviceapp = map(string)
  }))
}



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
      serviceplan = map(object({
        sku = string
        os_type = string

      }))
      serviceapp = map(string)
  }))
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