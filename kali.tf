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

locals {
  client_public_key = file("publickey")
}

resource "null_resource" "kali_setup" {
  depends_on = [azurerm_linux_virtual_machine.kali_machine]

  connection {
    type        = "ssh"
    host        = azurerm_linux_virtual_machine.kali_machine.public_ip_address
    user        = var.kali-user
    private_key = file("~/.ssh/id_rsa")
  }
    
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y",
      "sudo DEBIAN_FRONTEND=noninteractive apt install kali-linux-everything -y",
      "touch ~/.hushlogin",
      "sudo DEBIAN_FRONTEND=noninteractive apt install wireguard -y",
      "umask 077",
      "wg genkey > privatekey",
      "echo \"[Interface]\nPrivateKey = $(cat privatekey)\nAddress = 10.1.10.1/24\nListenPort = 51820\n\n[Peer]\nPublicKey = ${local.client_public_key}\nAllowedIPs = 10.1.10.2/32\" | sudo tee /etc/wireguard/wg0.conf",
      "sudo wg-quick up wg0",
      "sudo systemctl enable wg-quick@wg0"
    ]
  }
}

resource "null_resource" "get_wg_public_key" {
  depends_on = [null_resource.kali_setup]

  provisioner "local-exec" {
    command = "ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa kali@${azurerm_linux_virtual_machine.kali_machine.public_ip_address} 'cat publickey' > kali_public_key"
  }
}

data "local_file" "wg_public_key" {
  depends_on = [null_resource.get_wg_public_key]

  filename = "kali_public_key"
}
