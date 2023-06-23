# Note: You must set the environment variables for "TF_VAR_ARM_SUBSCRIPTION_ID" 

variable "ARM_SUBSCRIPTION_ID" { # should be overriden by environment variable
  type = string
  default = "" # leave blank
}

variable "storage_account_name" {
  type = string
  default = "ethicalhackingstorage3"
}

variable "storage_container_name" {
  type = string
  default = "ethicalhackingcontainer3"
}

variable "mssql_server_name" {
  type = string 
  default = "ethicalhackingmssql3"
}

variable "kali-user" {
  type = string
  default = "kali"
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

variable "scripts_dir" {
  type = string
  default = "./scripts"
}

variable "resources_dir" {
  type = string
  default = "./resources"
}

