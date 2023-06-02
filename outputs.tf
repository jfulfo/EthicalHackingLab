output "kali_public_ip_address" {
  value = azurerm_linux_virtual_machine.kali_machine.public_ip_address
  description = "The public IP address of the VM."
}

output "ad_public_ip_address" {
  value = azurerm_windows_virtual_machine.ad_machine.public_ip_address
  description = "The public IP address of the VM."
}

output "ms3_public_ip_address" {
  value = azurerm_windows_virtual_machine.ms3_machine.public_ip_address
  description = "The public IP address of the VM."
}
