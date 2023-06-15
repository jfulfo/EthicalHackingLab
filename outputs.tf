output "kali_public_ip_address" {
  value = azurerm_linux_virtual_machine.kali_machine.public_ip_address
  description = "The public IP address of the Kali VM."
}

output "kali_private_ip_address" {
  value = azurerm_linux_virtual_machine.kali_machine.private_ip_address
  description = "The private IP address of the Kali VM."
}

output "kali_wg_public_key" {
  value = trimspace(data.local_file.wg_public_key.content)
  description = "The WireGuard public key of the Kali VM."
}

output "ad_public_ip_address" {
  value = azurerm_windows_virtual_machine.ad_machine.public_ip_address
  description = "The public IP address of the Active Directory VM."
}

output "ms3_windows_public_ip_address" {
  value = azurerm_windows_virtual_machine.ms3_windows.public_ip_address
  description = "The public IP address of the MS3 Windows VM."
}

output "ms3_linux_public_ip_address" {
  value = azurerm_linux_virtual_machine.ms3_linux.public_ip_address
  description = "The public IP address of the MS3 Linux VM."
}

output "NOTE" {
  value = "The ms3 windows machine is a placeholder since the packer build is not working"
}

output "connect_to_kali" {
  value = "use ssh kali@{kali_private_ip_address} to connect to the Kali VM, ensure that wireguard configuration is set up correctly"
}
