resource "azurerm_network_interface" "ni_ms3" {
  name                = "ni_ms3"
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
  network_interface_ids = [azurerm_network_interface.ni_ms3.id]

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

