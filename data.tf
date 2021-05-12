# This is the recommended work around to get a dynamic ip adress on VM creation

data "azurerm_public_ip" "va-demo-ip-data" {
  name                = azurerm_public_ip.va-demo-ip.name
  resource_group_name = azurerm_linux_virtual_machine.va-demo-instance.resource_group_name
  depends_on          = [azurerm_linux_virtual_machine.va-demo-instance]
}
