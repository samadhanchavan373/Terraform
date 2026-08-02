resource "null_resource" "copyfiles" {
  count = var.virtual_machine_count
  provisioner "file" {
    content     = "<h1>This is web vm ${azurerm_linux_virtual_machine.linuxvm[count.index].computer_name}</h1>"
    destination = "/home/linuxadmin/Default.html"

    connection {
      type        = "ssh"
      user        = "linuxadmin"
      password    = "testTEST@1234"
      host        = var.virtual_machines_ip_addresses[count.index]
    }

  }

  provisioner "remote-exec" {
    inline = [
         "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do sleep 5; done",
      "sudo mv /home/linuxadmin/Default.html /var/www/html/Default.html"
    ]

    connection {
       type        = "ssh"
      user        = "linuxadmin"
      password    = "testTEST@1234"
      host        = var.virtual_machines_ip_addresses[count.index]
    }
  }

  depends_on = [azurerm_linux_virtual_machine.linuxvm] # Ensure the VM is created before copying files
}