resource "azurerm_public_ip" "pip_ms3_linux" {
  name                = "public_ip_ms3_linux"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "ni_ms3_linux" {
  name                = "ni_ms3_linux"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_ms3_linux.id
  }
}


resource "azurerm_linux_virtual_machine" "ms3_linux" {
  name                = "MS3Linux"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_D2s_v3"
  admin_username      = var.ms3-linux-user
  network_interface_ids = [azurerm_network_interface.ni_ms3_linux.id]

  admin_ssh_key {
    username       = var.ms3-linux-user
    public_key     = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_id = "/subscriptions/${var.SUBSCRIPTION_ID}/resourceGroups/ResourceGroup1/providers/Microsoft.Compute/images/ms3-linux"

  depends_on = [
    null_resource.ms3_linux_packer
  ]
}
