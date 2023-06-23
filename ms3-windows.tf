resource "azurerm_network_interface" "nic_ms3_windows" {
  name                = "nic_ms3_windows"
  location            = azurerm_resource_group.target_rg.location
  resource_group_name = azurerm_resource_group.target_rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.target_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "ms3_windows" {
  name                = "MS3Windows"
  resource_group_name = azurerm_resource_group.target_rg.name
  location            = azurerm_resource_group.target_rg.location
  size                = "Standard_D2s_v3"
  admin_username      = var.ms3-windows-user
  admin_password      = var.ms3-windows-password
  network_interface_ids = [azurerm_network_interface.nic_ms3_windows.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2008-R2-SP1"
    version   = "latest"
  }
}


resource "azurerm_virtual_machine_extension" "ms3_windows_extension" {
  name                 = "ms3_windows_extension"
  virtual_machine_id   = azurerm_windows_virtual_machine.ms3_windows.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
    {
      "fileUris": ["http://${var.storage_account_name}.blob.core.windows.net/${var.storage_container_name}/ms3_windows_provision.ps1"],
      "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -File ms3_windows_provision.ps1 \"${var.storage_account_name}\" \"${var.storage_container_name}\""
    }
SETTINGS

  depends_on = [null_resource.upload_provisioners]
}
