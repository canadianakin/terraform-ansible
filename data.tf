# This is the recommended work around to get a dynamic ip adress on VM creation

data "azurerm_public_ip" "dt-demo-ip-data1" {
  name                = azurerm_public_ip.dt-demo-ip1.name
  resource_group_name = azurerm_linux_virtual_machine.dt-demo-instance1.resource_group_name
  depends_on          = [azurerm_linux_virtual_machine.dt-demo-instance1]
}

data "azurerm_public_ip" "dt-demo-ip-data2" {
  name                = azurerm_public_ip.dt-demo-ip2.name
  resource_group_name = azurerm_linux_virtual_machine.dt-demo-instance2.resource_group_name
  depends_on          = [azurerm_linux_virtual_machine.dt-demo-instance2]
}