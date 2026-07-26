webapp-environment =  {

    "production" = {
        serviceplan = {
            serviceplan220499 = {
                sku = "S1"
                os = "Windows"
            } 
        }
        serviceapp = {samadhanwebapp = "serviceplan220499", samadhanwebapp02 = "serviceplan220499"}
    }
}

tags = {
  "commontags" = {
    department = "security"
    contact = "abc@abc.com"
  }
}

webapp-slots = [
  "samadhanwebapp", "staging"
]

db_app_environemnt = {
  production = {
    server = {
    sqlserver22041999 = {
      databases = {
          appdb = {
            sku = "S0"
            sampledb = null
          }
          AdventureWorksLT = {
            sku = "S0"
            sampledb = "AdventureWorksLT"
          }
      }
    }
    }
  }
}

app-setup = ["sqlserver22041999" , "appdb"]


web-environment = {
  production = {
    serviceplan = {
            serviceplan220499 = {
                sku = "B1"
                os_type = "Windows"
            } 
        }
        serviceapp = {samadhanwebapp = "serviceplan220499"}
  }
}


app-environment ={
  production ={
    virtual_network_name      = "app-network"
      virtual_network_cidrblock = "10.0.0.0/16"
  
  subnets ={
    websubnet01 ={
      cidrblock = "10.0.0.0/24",
      machines = null
    }
    dbsubnet01 = {
      cidrblock = "10.0.1.0/24",
      machines = {
        dbvm01 = {
           nic_name       = "dbinterface01"
           Public_ip_name = "dpip01"
        }
      }
    }
  }

  serviceplan = {
    serviceplan220499 ={
      sku = "B1"
      os_type = "Windows"
    }

  }
  serviceapp = {
    webapp220499 = "serviceplan220499"
  }
  }
}