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

variable "storage_account_name" {
    type = string
    default = "ethicalhackingstorage1"
}

variable "storage_container_name" {
    type = string
    default = "ethicalhackingcontainer1"
}


variable "scripts_dir" {
  type = string
  default = "./scripts"
  description = "Directory containing scripts to be uploaded to the VM"
}

variable "resources_dir" {
  type = string
  default = "./resources"
  description = "Directory containing resources to be uploaded to the VM"
}

packer {
  required_plugins {
    azure = {
      version = "1.4.2"
      source  = "github.com/hashicorp/azure"
    }
  }
}

source "azure-arm" "ms3-windows" {
  subscription_id = var.ARM_SUBSCRIPTION_ID  
  client_id = var.ARM_CLIENT_ID  
  client_secret = var.ARM_CLIENT_SECRET  
  tenant_id = var.ARM_TENANT_ID  

  managed_image_resource_group_name = "ResourceGroup1"  
  managed_image_name = "ms-windows"  

  os_type = "Windows"  
  image_publisher = "MicrosoftWindowsServer"  
  image_offer = "WindowsServer"  
  image_sku = "2008-R2-SP1"

  location = "East US"  
  vm_size = "Standard_D2_v2"

  communicator = "winrm"
  winrm_use_ssl = true
  winrm_insecure = true
  winrm_timeout = "15m"
  winrm_username = "packer"
}

build {
  sources = ["source.azure-arm.ms3-windows"]  
  name = "ms3-windows"

  provisioner "shell-local" {
    only_on = ["linux", "darwin"]
    inline = ["cd ${var.resources_dir} && ./download-windows-files.sh"]
  }

  provisioner "shell-local" {
    only_on = ["windows"]
    inline = ["cd ${var.resources_dir} && powershell ./download-windows-files.ps1"]
  }

  provisioner "shell-local" {
    inline = [
      "zip -r scripts.zip scripts",
      "zip -r resources.zip resources",
      "az storage blob upload --account-name ${var.storage_account_name} --name scripts.zip --type block --file scripts.zip --container-name ${var.storage_container_name} --overwrite",
      "az storage blob upload --account-name ${var.storage_account_name} --name resources.zip --type block --file resources.zip --container-name ${var.storage_container_name} --overwrite"
    ]
  }

  provisioner "powershell" {
    inline = [
      "$webClient = New-Object System.Net.WebClient",
      "$webClient.DownloadFile('http://${var.storage_account_name}.blob.core.windows.net/${var.storage_container_name}/scripts.zip', 'C:/scripts.zip')",
      "$webClient.DownloadFile('http://${var.storage_account_name}.blob.core.windows.net/${var.storage_container_name}/resources.zip', 'C:/resources.zip')",
      "mkdir C:\\vagrant",
      "$shell = New-Object -ComObject Shell.Application",
      "$zip = $shell.NameSpace('C:\\scripts.zip')",
      "$destination = $shell.NameSpace('C:\\vagrant')",
      "$destination.CopyHere($zip.Items(), 0x10)",
      "$zip = $shell.NameSpace('C:\\resources.zip')",
      "$destination = $shell.NameSpace('C:\\vagrant')",
      "$destination.CopyHere($zip.Items(), 0x10)",
      "rm C:/scripts.zip",
      "rm C:/resources.zip"
    ]
  }

  provisioner "windows-shell" {
    remote_path     = "C:/Windows/Temp/script.bat"
    execute_command = "cmd /c C:/Windows/Temp/script.bat"
    scripts = [
      #"${var.scripts_dir}/configs/update_root_certs.bat",
      "${var.scripts_dir}/configs/enable-rdp.bat",
      "${var.scripts_dir}/configs/disable_firewall.bat"
    ]
  }

  /*
  provisioner "windows-shell" {
    remote_path     = "C:/Windows/Temp/script.bat"
    execute_command = "cmd /c C:/Windows/Temp/script.bat"
    scripts         = ["${var.scripts_dir}/configs/disable_firewall.bat"]
  }
  */

  provisioner "windows-restart" {}

  provisioner "powershell" {
    scripts = ["${var.scripts_dir}/installs/install_dotnet45.ps1"]
  }

  provisioner "windows-restart" {}

  provisioner "powershell" {
    scripts = ["${var.scripts_dir}/installs/install_wmf.ps1"]
  }

  provisioner "windows-restart" {
    pause_before = "180s"
  }

  provisioner "powershell" {
    scripts = [
      #"${var.scripts_dir}/configs/vagrant-ssh.ps1",
      "${var.scripts_dir}/installs/chocolatey.ps1"
    ]
    pause_before = "60s"
  }

  provisioner "windows-restart" {}

  provisioner "powershell" {
    #elevated_user     = "Administrator"
    #elevated_password = ""
    scripts = [
      "${var.scripts_dir}/installs/setup_iis.bat",
      "${var.scripts_dir}/installs/setup_snmp.bat"
    ]
  }

  provisioner "windows-restart" {}

  provisioner "windows-shell" {
    remote_path     = "C:/Windows/Temp/script.bat"
    execute_command = "cmd /c C:/Windows/Temp/script.bat"
    scripts = [
      "${var.scripts_dir}/configs/apply_password_settings.bat",
      "${var.scripts_dir}/configs/create_users.bat",
    ]
  }

  provisioner "windows-restart" {}

  provisioner "windows-shell" {
    remote_path     = "C:/Windows/Temp/script.bat"
    execute_command = "cmd /c C:/Windows/Temp/script.bat"
    scripts = [
      "${var.scripts_dir}/configs/disable-auto-logon.bat",
      "${var.scripts_dir}/chocolatey_installs/chocolatey-compatibility.bat",
      "${var.scripts_dir}/chocolatey_installs/boxstarter.bat",
      "${var.scripts_dir}/chocolatey_installs/7zip.bat",
    ]
  }

  provisioner "windows-restart" {}

  provisioner "windows-shell" {
    remote_path     = "C:/Windows/Temp/script.bat"
    execute_command = "cmd /c C:/Windows/Temp/script.bat"
    scripts = [
      "${var.scripts_dir}/installs/setup_ftp_site.bat",
      "${var.scripts_dir}/chocolatey_installs/java.bat"
    ]
  }

  provisioner "windows-restart" {}

  provisioner "windows-shell" {
    remote_path = "C:/Windows/Temp/script.bat"
    execute_command = "cmd /c C:/Windows/Temp/script.bat"
    scripts = [
      "${var.scripts_dir}/chocolatey_installs/tomcat.bat",
      "${var.scripts_dir}/installs/setup_apache_struts.bat",
      "${var.scripts_dir}/installs/setup_glassfish.bat",
      "${var.scripts_dir}/installs/start_glassfish_service.bat",
      "${var.scripts_dir}/installs/setup_jenkins.bat",
      "${var.scripts_dir}/chocolatey_installs/vcredist2008.bat",
      "${var.scripts_dir}/installs/install_wamp.bat",
      "${var.scripts_dir}/installs/start_wamp.bat",
      "${var.scripts_dir}/installs/install_wordpress.bat",
      "${var.scripts_dir}/installs/install_openjdk6.bat",
      "${var.scripts_dir}/installs/setup_jmx.bat",
      "${var.scripts_dir}/chocolatey_installs/ruby.bat",
      "${var.scripts_dir}/installs/install_devkit.bat"
    ]
  }

  provisioner "windows-restart" {}

  provisioner "windows-shell" {
    remote_path = "C:/Windows/Temp/script.bat"
    execute_command = "cmd /c C:/Windows/Temp/script.bat"
    scripts = [
      "${var.scripts_dir}/installs/install_rails_server.bat",
      "${var.scripts_dir}/installs/setup_rails_server.bat",
      "${var.scripts_dir}/installs/install_rails_service.bat",
      "${var.scripts_dir}/installs/setup_webdav.bat",
      "${var.scripts_dir}/installs/setup_mysql.bat",
      "${var.scripts_dir}/installs/install_manageengine.bat",
      "${var.scripts_dir}/installs/setup_axis2.bat",
      "${var.scripts_dir}/installs/install_backdoors.bat",
      "${var.scripts_dir}/configs/configure_firewall.bat",
      "${var.scripts_dir}/installs/install_elasticsearch.bat",
      "${var.scripts_dir}/installs/install_flags.bat"
    ]
  }

  provisioner "windows-shell" {
    remote_path = "C:/Windows/Temp/script.bat"
    execute_command = "cmd /c C:/Windows/Temp/script.bat"
    scripts = [
      #"${var.scripts_dir}/installs/vm-guest-tools.bat",
      "${var.scripts_dir}/configs/packer_cleanup.bat"
    ]
  }

  provisioner "powershell" {
    inline = [
      "mkdir -p C:/startup"
    ]
  }

  provisioner "file" {
    source = "${var.scripts_dir}/configs/disable_firewall.bat"
    destination = "C:/startup/disable_firewall.bat"
  }

  provisioner "file" {
    source = "${var.scripts_dir}/configs/enable_firewall.bat"
    destination = "C:/startup/enable_firewall.bat"
  }

  provisioner "file" {
    source = "${var.scripts_dir}/configs/configure_firewall.bat"
    destination = "C:/startup/configure_firewall.bat"
  }

  provisioner "file" {
    source = "${var.scripts_dir}/installs/install_share_autorun.bat"
    destination = "C:/startup/install_share_autorun.bat"
  }

  provisioner "file" {
    source = "${var.scripts_dir}/installs/setup_linux_share.bat"
    destination = "C:/startup/setup_linux_share.bat"
  }
}
