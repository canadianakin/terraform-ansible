output "vt_demo_instance_public_ip" {
  value       = data.azurerm_public_ip.vt-demo-ip-data.ip_address
}