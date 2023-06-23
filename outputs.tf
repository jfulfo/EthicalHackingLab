output "kali_public_ip_address" {
  value = azurerm_linux_virtual_machine.kali_machine.public_ip_address
  description = "The public IP address of the Kali VM."
}

output "kali_private_ip_address" {
  value = azurerm_linux_virtual_machine.kali_machine.private_ip_address
  description = "The private IP address of the Kali VM."
}

output "kali_wg_public_key" {
  value = data.local_file.kali_public_key.content
  sensitive = false
  description = "The WireGuard public key of the Kali VM."
}

output "connect_to_kali" {
  value = "use ssh kali@${azurerm_linux_virtual_machine.kali_machine.private_ip_address} to connect to the Kali VM, ensure that wireguard configuration is set up correctly. Use sudo apt install kali-linux-everything after logging in"
}
