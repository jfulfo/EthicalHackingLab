resource "azurerm_public_ip" "pip_kali" {
    name                = "public_ip"
    location            = azurerm_resource_group.rg2.location
    resource_group_name = azurerm_resource_group.rg2.name
    allocation_method   = "Static"
    sku                 = "Standard"
}

resource "azurerm_network_interface" "ni_kali" {
    name                = "ni_kali"
    location            = azurerm_resource_group.rg2.location
    resource_group_name = azurerm_resource_group.rg2.name

    ip_configuration {
        name                          = "ipconfig"
        subnet_id                     = azurerm_subnet.subnet2.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.pip_kali.id
    }
}

resource "azurerm_linux_virtual_machine" "kali_machine" {
    name                = "KaliMachine"
    resource_group_name = azurerm_resource_group.rg2.name
    location            = azurerm_resource_group.rg2.location
    size                = "Standard_D2s_v3"
    admin_username      = var.kali-user
    network_interface_ids = [azurerm_network_interface.ni_kali.id]

    admin_ssh_key {
        username       = var.kali-user
        public_key     = file("~/.ssh/id_rsa.pub")
    }

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

/*
resource "null_resource" "install_wireguard" {
    provisioner "local-exec" {
        command = "ssh -o \"StrictHostKeyChecking no\" -i ~/.ssh/id_rsa adminuser@${azurerm_linux_virtual_machine.kali_machine.public_ip_address} < setup_wireguard.sh"
    }
}
*/

