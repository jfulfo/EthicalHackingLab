resource "azurerm_mssql_server" "mssql_server" {
  name                         = var.mssql_server_name
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "AdminUser"
  administrator_login_password = "AdminPassword123!"
  minimum_tls_version          = "1.2"

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_mssql_database" "mssql_db" {
  name           = "mssqldb"
  server_id      = azurerm_mssql_server.mssql_server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb    = 20
  sku_name       = "S0"
  read_scale     = false
  zone_redundant = false

  tags = {
    environment = "Production"
  }

  depends_on = [azurerm_mssql_server.mssql_server]
}

