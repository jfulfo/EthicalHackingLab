# main.tf for lab1
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "ResourceGroup1"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "ni" {
  name                = "ni"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

  
# Create the Active Directory machine...

resource "azurerm_windows_virtual_machine" "ad_machine" {
  name                 = "ad_machine"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  size                 = "Standard_DS2_v3"
  admin_username       = "localadmin"
  admin_password       = "P@ssw0rd1234!"
  network_interface_ids = [azurerm_network_interface.ni.id]

    os_disk {
        name              = "ad_osdisk"
        caching           = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2019-Datacenter"
        version   = "latest"
    }
}

# Create the Metasploitable3 Windows machine...
resource "azurerm_windows_virtual_machine" "ms3_windows_machine" {
  name                = "MS3WindowsMachine"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  admin_password      = "P@ssw0rd!"
  network_interface_id = azurerm_network_interface.ni.id

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_id = "/subscriptions/{your-subscription-id}/resourceGroups/{your-resource-group}/providers/Microsoft.Compute/images/ms3WindowsImage"
}


# Create the SQL Server machine...
resource "azurerm_sql_server" "sql_server" {
  name                         = "SqlServer"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "adminuser"
  administrator_login_password = "{admin-password}"
}

resource "azurerm_sql_database" "sql_database" {
  name                = "SqlDatabase"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  server_name         = azurerm_sql_server.sql_server.name
  collation           = "SQL_Latin1_General_CP1_CI_AS"
  edition             = "Standard"
  requested_service_objective_name = "S0"
}


# Create the Metasploitable3 Linux machine...
resource "azurerm_linux_virtual_machine" "ms3_linux_machine" {
  name                = "MS3LinuxMachine"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  network_interface_id = azurerm_network_interface.ni.id

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_id = "/subscriptions/{your-subscription-id}/resourceGroups/{your-resource-group}/providers/Microsoft.Compute/images/ms3LinuxImage"
}

# Create the Kali Linux machine...
resource "azurerm_linux_virtual_machine" "kali_linux_machine" {
  name                = "KaliLinuxMachine"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  network_interface_id = azurerm_network_interface.ni.id

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_id = "/subscriptions/{your-subscription-id}/resourceGroups/{your-resource-group}/providers/Microsoft.Compute/images/kaliLinuxImage"
}


