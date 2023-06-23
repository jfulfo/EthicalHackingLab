resource "azurerm_network_interface" "nic_pivot" {
  name                = "nic_pivot"
  location            = azurerm_resource_group.target_rg.location
  resource_group_name = azurerm_resource_group.target_rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.pivot_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "pivot" {
  name                = "Pivot"
  resource_group_name = azurerm_resource_group.target_rg.name
  location            = azurerm_resource_group.target_rg.location
  size                = "Standard_D2s_v3"
  admin_username      = var.pivot-user
  admin_password      = var.pivot-password
  disable_password_authentication = false
  network_interface_ids = [azurerm_network_interface.nic_pivot.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
