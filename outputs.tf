output "kali_public_ip_address" {
  value = azurerm_linux_virtual_machine.kali_machine.public_ip_address
  description = "The public IP address of the Kali VM."
}

/*
output "ad_public_ip_address" {
  value = azurerm_windows_virtual_machine.ad_machine.public_ip_address
  description = "The public IP address of the Active Directory VM."
}

output "ms3_windows_public_ip_address" {
  value = azurerm_windows_virtual_machine.ms3_windows.public_ip_address
  description = "The public IP address of the MS3 Windows VM."
}
*/

output "ms3_linux_public_ip_address" {
  value = azurerm_linux_virtual_machine.ms3_linux.public_ip_address
  description = "The public IP address of the MS3 Linux VM."
}
