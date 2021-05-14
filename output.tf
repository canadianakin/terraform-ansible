output "dt_demo_instance_public_ip1" {
  description = "The ip address of the first vm"
  value       = data.azurerm_public_ip.dt-demo-ip-data1.ip_address
}

output "dt_demo_instance_public_ip2" {
  description = "The ip address of the second vm"
  value       = data.azurerm_public_ip.dt-demo-ip-data2.ip_address
}

