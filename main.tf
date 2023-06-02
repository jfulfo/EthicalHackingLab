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
