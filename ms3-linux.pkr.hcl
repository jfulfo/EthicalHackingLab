variable "ARM_SUBSCRIPTION_ID" {
  type = string
  description = "Azure Subscription ID"
  sensitive = true
}

variable "ARM_CLIENT_ID" {
  type = string
  description = "Azure Client ID"
  sensitive = true
}

variable "ARM_CLIENT_SECRET" {
  type = string
  description = "Azure Client Secret"
  sensitive = true
}

variable "ARM_TENANT_ID" {
  type = string
  description = "Azure Tenant ID"
  sensitive = true
}

packer {
  required_plugins {
    azure = {
      version = "1.4.2"
      source = "github.com/hashicorp/azure"
    }
    chef = {
      version = ">= 1.0.0"
      source = "github.com/hashicorp/chef"
    }
  }
}

source "azure-arm" "ms3-linux" {
  subscription_id = var.ARM_SUBSCRIPTION_ID
  client_id       = var.ARM_CLIENT_ID
  client_secret   = var.ARM_CLIENT_SECRET
  tenant_id       = var.ARM_TENANT_ID

  managed_image_resource_group_name = "ResourceGroup1"
  managed_image_name = "ms3-linux"

  os_type  = "Linux"
  image_publisher = "Canonical"
  image_offer     = "UbuntuServer"
  image_sku       = "14.04.0-LTS"

  location = "East US"
  vm_size  = "Standard_D2s_v3"
}

build {
  sources = ["source.azure-arm.ms3-linux"]
  name = "ms3-linux"

  provisioner "chef-solo" {
    cookbook_paths = ["cookbooks"]
    version = "13.8.5"
    run_list = [
      "apt::default",
      "iptables::default",
      "metasploitable::users",
      "metasploitable::mysql",
      "metasploitable::apache_continuum",
      "metasploitable::apache",
      "metasploitable::php_545",
      "metasploitable::phpmyadmin",
      "metasploitable::proftpd",
      "metasploitable::docker",
      "metasploitable::samba",
      "metasploitable::sinatra",
      "metasploitable::unrealircd",
      "metasploitable::chatbot",
      "metasploitable::payroll_app",
      "metasploitable::readme_app",
      "metasploitable::cups",
      "metasploitable::drupal",
      "metasploitable::knockd",
      "metasploitable::iptables",
      "metasploitable::flags",
      "metasploitable::sshd",
      #"metasploitable::log4shell",
      "metasploitable::clear_cache"
    ]
  }

  provisioner "shell" {
    inline = [ "sudo apt -y remove chef" ]
  }
}

