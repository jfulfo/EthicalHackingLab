resource "azurerm_network_interface" "nic_mssql" {
    name                = "nic_mssql"
    location            = azurerm_resource_group.target_rg.location
    resource_group_name = azurerm_resource_group.target_rg.name

    ip_configuration {
        name                          = "ipconfig"
        subnet_id                     = azurerm_subnet.target_subnet.id
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_windows_virtual_machine" "mssql_server" {
  name = "MSSQLServer"
  resource_group_name = azurerm_resource_group.target_rg.name 
  location = azurerm_resource_group.target_rg.location
  size = "Standard_D2s_v3"
  admin_username = var.mssql-user
  admin_password = var.mssql-password
  network_interface_ids = [azurerm_network_interface.nic_mssql.id]

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftSQLServer"
    offer = "SQL2019-WS2019"
    sku = "Enterprise"
    version = "latest"
  }
}
