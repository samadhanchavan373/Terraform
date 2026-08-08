variable "resource_grp_name" {
  description = "Name of the resource group"
  type        = string
}


variable "web-environment"{
  type = map(object({
    serviceplan_plan_os_type = string
    serviceplan_plan_sku = string
    serviceplan_plan_location = string
    webapp_name = string
  }))
}