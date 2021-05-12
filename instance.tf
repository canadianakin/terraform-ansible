# demo instance
resource "azurerm_linux_virtual_machine" "va-demo-instance" {
  name                            = "${var.prefix}-vm"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.va-demo.name
  network_interface_ids           = ["${azurerm_network_interface.va-demo-interface.id}"]
  size                            = "Standard_A1_v2"
  admin_username                  = "adminuser"
  computer_name                   = "demo-instance"
  disable_password_authentication = true

  tags = {
    env = "ansible"
  }                           

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_public_ip" "va-demo-ip" {
  name                = "instance-1-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.va-demo.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "va-demo"
  }
}