# This is the recommended work around to get a dynamic ip adress on VM creation

data "azurerm_public_ip" "dt-demo-ip-data" {
  name                = azurerm_public_ip.dt-demo-ip.name
  resource_group_name = azurerm_linux_virtual_machine.dt-demo-instance.resource_group_name
  depends_on          = [azurerm_linux_virtual_machine.dt-demo-instance]
}
