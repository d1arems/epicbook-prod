output "public_ip_address" {
  description = "The actual public IP address assigned to the VM"
  value       = azurerm_public_ip.main.ip_address
}

output "admin_username" {
 description = "Name of the user"
 value       = azurerm_linux_virtual_machine.main.admin_username
}
