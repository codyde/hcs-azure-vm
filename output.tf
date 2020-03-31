output "public_ip_address1" {
  description = "The actual ip address allocated for the resource."
  value       = azurerm_public_ip.this1.*.ip_address
}

output "public_ip_address2" {
  description = "The actual ip address allocated for the resource."
  value       = azurerm_public_ip.this2.*.ip_address
}