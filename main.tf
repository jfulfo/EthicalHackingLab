provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "ResourceGroup1"
  location = "East US"
}

resource "azurerm_resource_group" "rg2" {
  name     = "ResourceGroup2"
  location = "West US"
}

resource "null_resource" "ms3_packer" {
  depends_on = [azurerm_resource_group.rg]

  provisioner "local-exec" {
    command = "packer build metasploitable3.pkr.hcl"
  }
}

