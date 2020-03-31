/*
output "public_ip_address1" {
  description = "The actual ip address allocated for the resource."
  value       = azurerm_public_ip.vm1.*.ip_address
}

output "public_ip_address2" {
  description = "The actual ip address allocated for the resource."
  value       = azurerm_public_ip.vm2.*.ip_address
}
*/