variable "resource_grp_name" {
  description = "Name of the resource group"
  type        = string
}

variable "resource_grp_location" {
  description = "Location of the resource group"
  type        = string
}


variable "traffic-manager-endpoints" {
  type = map(object({
    endpoint_priority = string
    endpoint_weight   = string
  }))
}

variable "webapp-ids" {
  type = list(string)
}

variable "webapp-hostnames" {
  type = list(string)
}

variable "secondary-app-service-name" {
  type = string
}
