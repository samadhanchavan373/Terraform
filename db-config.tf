resource "null_resource" "addfiles" {
  triggers = {
    sql_hash     = filemd5("02.sql")
    command_hash = md5(join("", [
        "sudo cloud-init status --wait",
        "sudo mysql -u root < 02.sql",
        "sudo sed -i 's/.*bind-address.*/bind-address = 10.0.1.4/' /etc/mysql/mysql.conf.d/mysqld.cnf",
        "sudo systemctl restart mysql"
    ]))
  }

  provisioner "file" {
    source = "02.sql"
    destination = "/home/linuxadmin/02.sql"

    connection {
      type        = "ssh"
      user        = "linuxadmin"
      password    = var.admin_password
      host        = "${azurerm_public_ip.web-pip["dbvm01"].ip_address}"
    }

  }

  provisioner "remote-exec" {
 
    connection {
      type        = "ssh"
      user        = "linuxadmin"
      password    = var.admin_password
      host        = "${azurerm_public_ip.web-pip["dbvm01"].ip_address}"
    }

    inline = [
        "sudo cloud-init status --wait",
        "sudo mysql -u root < 02.sql",
        "sudo sed -i 's/.*bind-address.*/bind-address = 10.0.1.4/' /etc/mysql/mysql.conf.d/mysqld.cnf",
        "sudo systemctl restart mysql"
    ]
  }

  depends_on = [azurerm_linux_virtual_machine.linuxvm,
   azurerm_network_security_group.app-nsg]
}