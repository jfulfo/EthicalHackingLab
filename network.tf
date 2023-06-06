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

    security_rule {
        name                       = "RDP_Access"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
    subnet_id                 = azurerm_subnet.subnet.id
    network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_security_group" "nsg2" {
    name                = "NSG2"
    location            = azurerm_resource_group.rg2.location
    resource_group_name = azurerm_resource_group.rg2.name

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

resource "azurerm_subnet_network_security_group_association" "subnet2_nsg2_association" {
    subnet_id                 = azurerm_subnet.subnet2.id
    network_security_group_id = azurerm_network_security_group.nsg2.id
}

resource "azurerm_virtual_network" "vnet2" {
  name                = "vnet2"
  resource_group_name = azurerm_resource_group.rg2.name
  location            = azurerm_resource_group.rg2.location
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  resource_group_name  = azurerm_resource_group.rg2.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = ["10.1.1.0/24"]
}
