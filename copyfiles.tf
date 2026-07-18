resource "null_resource" "copyfiles" {
  provisioner "file" {
    source = "Default.html"
    destination = "/home/${var.admin_username}/Default.html"

    connection {
      type        = "ssh"
      user        = var.admin_username
      password    = var.admin_password
      host        = "${azurerm_public_ip.web-pip2["appvm2"].ip_address}"
    }

  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /home/${var.admin_username}/Default.html /var/www/html/Default.html"
    ]

    connection {
      type        = "ssh"
      user        = var.admin_username
      password    = var.admin_password
      host        = "${azurerm_public_ip.web-pip2["appvm2"].ip_address}"
    }
  }

  depends_on = [azurerm_linux_virtual_machine.linuxvm,
   azurerm_network_security_group.app-nsg]
}