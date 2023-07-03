resource "azurerm_network_interface" "nic_ms3_linux" {
  name                = "nic_ms3_linux"
  location            = azurerm_resource_group.target_rg.location
  resource_group_name = azurerm_resource_group.target_rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.target_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_linux_virtual_machine" "ms3_linux" {
  name                = "MS3Linux"
  resource_group_name = azurerm_resource_group.target_rg.name
  location            = azurerm_resource_group.target_rg.location
  size                = "Standard_D2s_v3"
  admin_username      = var.ms3-linux-user
  network_interface_ids = [azurerm_network_interface.nic_ms3_linux.id]

  admin_ssh_key {
    username       = var.ms3-linux-user
    public_key     = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_id = "/subscriptions/${var.ARM_SUBSCRIPTION_ID}/resourceGroups/${var.target_resource_group_name}/providers/Microsoft.Compute/images/ms3-linux"

  depends_on = [
    null_resource.ms3_linux_packer
  ]
}
