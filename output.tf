output "dt_demo_instance_public_ip" {
  value       = data.azurerm_public_ip.dt-demo-ip-data.ip_address
}