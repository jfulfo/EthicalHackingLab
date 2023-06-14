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

resource "azurerm_storage_account" "sa" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  enable_https_traffic_only = false
}

resource "azurerm_storage_container" "sc" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "blob"
}

resource "null_resource" "ms3_linux_packer" {
  depends_on = [azurerm_resource_group.rg]

  provisioner "local-exec" {
    command = "packer build ms3-linux.pkr.hcl"
  }
}

