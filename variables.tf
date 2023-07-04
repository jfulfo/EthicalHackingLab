# Note: You must set the environment variables for "TF_VAR_ARM_SUBSCRIPTION_ID" 

variable "ARM_SUBSCRIPTION_ID" { # should be overriden by environment variable
  type = string
  default = "" # leave blank
}

variable "storage_account_name" {
  type = string
  default = "ethicalhackingstorage5"
}

variable "storage_container_name" {
  type = string
  default = "ethicalhackingcontainer5"
}

variable "mssql_server_name" {
  type = string 
  default = "ethicalhackingmssql5"
}

variable "attacker_resource_group_name" {
  type = string
  default = "production_attacker_group"
}

variable "target_resource_group_name" {
  type = string
  default = "production_target_group"
}

variable "kali-user" {
  type = string
  default = "kali"
}

variable "kali-password" {
  type = string
  default = "Kali123!"
}

variable "client_public_key" {
  type = string 
  default = "" 
}

variable "ad-user" {
  type = string
  default = "adadmin"
}

variable "ad-password" {
  type = string
  default = "SecurePassword1234!"
}

variable "ad-domain-name" {
  type = string
  default = "ethicalhacking.local"
}

variable "ad-administrator-password" {
  type = string
  default = "SecurePassword1234!"
}

variable "ms3-windows-user" {
  type = string
  default = "ms3admin"
}

variable "ms3-windows-password" {
  type = string
  default = "Metasploit1234!"
}

variable "ms3-linux-user" {
  type = string
  default = "ms3linux"
}

variable "mssql-user" {
  type = string
  default = "mssqladmin"
}

variable "mssql-password" {
  type = string
  default = "MSSQLPassword123!"
}

variable "pivot-user" {
  type = string
  default = "ubuntu"
}

variable "pivot-password" {
  type = string
  default = "Ubuntu123!"
}

variable "scripts_dir" {
  type = string
  default = "./scripts"
}

variable "resources_dir" {
  type = string
  default = "./resources"
}

