# This is the recommended work around to get a dynamic ip adress on VM creation

data "azurerm_public_ip" "vt-demo-ip-data" {
  name                = azurerm_public_ip.vt-demo-ip.name
  resource_group_name = azurerm_linux_virtual_machine.vt-demo-instance.resource_group_name
  depends_on          = [azurerm_linux_virtual_machine.vt-demo-instance]
}
