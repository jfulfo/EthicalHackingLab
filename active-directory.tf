resource "azurerm_network_interface" "nic_ad" {
    name                = "nic_ad"
    location            = azurerm_resource_group.target_rg.location
    resource_group_name = azurerm_resource_group.target_rg.name

    ip_configuration {
        name                          = "ipconfig"
        subnet_id                     = azurerm_subnet.target_subnet.id
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_windows_virtual_machine" "active_directory" {
  name                = "ActiveDirectory"
  resource_group_name = azurerm_resource_group.target_rg.name
  location            = azurerm_resource_group.target_rg.location
  size                = "Standard_D2s_v3"
  admin_username      = var.ad-user
  admin_password      = var.ad-password
  network_interface_ids = [azurerm_network_interface.nic_ad.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "ad" {
  name                 = "ad"
  virtual_machine_id   = azurerm_windows_virtual_machine.active_directory.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
    {
      "fileUris": ["http://${var.storage_account_name}.blob.core.windows.net/${var.storage_container_name}/active_directory_provision.ps1"],
      "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -File active_directory_provision.ps1 \"${var.ad-domain-name}\" \"${var.ad-administrator-password}\""
    }
SETTINGS

  depends_on = [null_resource.upload_provisioners]
}
