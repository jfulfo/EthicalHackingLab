resource "azurerm_public_ip" "pip_kali" {
  name                = "kali_public_ip"
  location            = azurerm_resource_group.attacker_rg.location
  resource_group_name = azurerm_resource_group.attacker_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic_kali" {
  name                = "nic_kali"
  location            = azurerm_resource_group.attacker_rg.location
  resource_group_name = azurerm_resource_group.attacker_rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.attacker_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_kali.id
  }
}

resource "azurerm_linux_virtual_machine" "kali_machine" {
  name                = "KaliMachine"
  resource_group_name = azurerm_resource_group.attacker_rg.name
  location            = azurerm_resource_group.attacker_rg.location
  size                = "Standard_D2s_v3"
  admin_username      = var.kali-user
  network_interface_ids = [azurerm_network_interface.nic_kali.id]

  admin_ssh_key {
    username       = var.kali-user
    public_key     = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 80
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

resource "azurerm_virtual_machine_extension" "kali_extension" {
  name                 = "kali_extension"
  virtual_machine_id   = azurerm_linux_virtual_machine.kali_machine.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
    {
      "fileUris": ["http://${var.storage_account_name}.blob.core.windows.net/${var.storage_container_name}/kali_provision.sh"],
      "commandToExecute": "./kali_provision.sh \"${data.local_file.kali_private_key.content}\" \"${data.local_file.client_public_key.content}\""
    }
SETTINGS

  timeouts {
    create = "90m"
  }

  depends_on = [null_resource.upload_provisioners]
}

