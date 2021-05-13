output "dt_demo_instance_public_ip" {
  description = "The ip address of the vm"
  value       = data.azurerm_public_ip.dt-demo-ip-data.ip_address
}