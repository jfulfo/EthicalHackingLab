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

resource "azurerm_public_ip" "pip_kali" {
    name                = "public_ip"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    allocation_method   = "Static"
    sku                 = "Standard"
}

resource "azurerm_network_interface" "ni_kali" {
    name                = "ni_kali"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
        name                          = "ipconfig"
        subnet_id                     = azurerm_subnet.subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.pip_kali.id
    }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "NSG"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH_Access"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "kali_linux_machine" {
    name                = "KaliLinuxMachine"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    size                = "Standard_D2s_v3"
    admin_username      = var.kali-user
    admin_password = var.kali-password
    network_interface_ids = [azurerm_network_interface.ni_kali.id]
    disable_password_authentication = false

    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "kali-linux"
        offer     = "kali"
        sku       = "kali"
        version   = "latest"
    }

    plan {
      publisher = "kali-linux"
      product   = "kali"
      name      = "kali"
    }
}
