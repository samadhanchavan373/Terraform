variable "vmname"{
 type = string
 description = "Name of the virtual machine"
}

variable "admin_username"{
 type = string
 description = "Username for the administrator account"
}

variable "admin_password"{
 type = string
 description = "Password for the administrator account"
 sensitive = true
}

variable "vm_size"{
    type = string
    description = "Size of the virtual machine"
    default = "Standard_B2as_v2"
}
