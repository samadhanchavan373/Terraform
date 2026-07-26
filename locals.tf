locals{
    resource_grp_location = "Central India"

    production_tags = {
        code = "${var.tags.commontags.department}-${var.tags.commontags.contact}"
        tier = "${var.tags.commontags.department}"
    }

    database_details = flatten([
        for server_key, server in var.db_app_environemnt.production.server : [
            for database_key, database in server.databases : {
                server_name     = server_key
                database_name   = database_key
                database_sku    = database.sku
                database_sample = database.sampledb
            }
        ]
    ])

     network_security_group_rules = [
    {
      priority               = 300
      destination_port_range = "22"
    }
  ]
}