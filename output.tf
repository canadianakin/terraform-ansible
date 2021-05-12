output "va_demo_instance_public_ip" {
  value = data.azurerm_public_ip.va-demo-ip-data.ip_address
}