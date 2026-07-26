/*resource "azurerm_mssql_server" "sqlserver" {
    for_each = var.db_app_environemnt.production.server
  name                         = each.key
  resource_group_name          = azurerm_resource_group.app-rg.name
  location                     = local.resource_grp_location
  version                      = "12.0"
  administrator_login          = "adminuser"
  administrator_login_password = "testTEST@1234"
  minimum_tls_version          = "1.2"
}


resource "azurerm_mssql_database" "appdb" {
    for_each = {for detail in local.database_details : detail.database_name => detail}
  name         = each.key
  server_id    = azurerm_mssql_server.sqlserver[each.value.server_name].id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = each.value.database_sku
  sample_name = each.value.database_sample
}


resource "azurerm_mssql_firewall_rule" "example" {

    for_each = var.db_app_environemnt.production.server
  name             = "AllowMyIp"
  server_id        = azurerm_mssql_server.sqlserver[each.key].id
  start_ip_address = "223.178.19.121"
  end_ip_address   = "223.178.19.121"
}

output "output_databse_details" {
  value = local.database_details
  
}

resource "null_resource" "database-setup"{
 provisioner "local-exec" {
   command = "sqlcmd -S ${azurerm_mssql_server.sqlserver[var.app-setup[0]].fully_qualified_domain_name} -U ${azurerm_mssql_server.sqlserver[var.app-setup[0]].administrator_login} -P ${azurerm_mssql_server.sqlserver[var.app-setup[0]].administrator_login_password} -d ${var.app-setup[1]} -i 01.sql"
 }

 depends_on = [ azurerm_mssql_database.appdb ]
}*/