# Note: You must set the environment variables for "TF_VAR_ARM_SUBSCRIPTION_ID" 
# Replace "client_public_key" with your Wireguard public key

variable "ARM_SUBSCRIPTION_ID" { # should be overriden by environment variable
  type = string
  default = "" # leave blank
}

variable "storage_account_name" {
  type = string
  default = "ethicalhackingstorage2"
}

variable "storage_container_name" {
  type = string
  default = "ethicalhackingcontainer2"
}

variable "mssql_server_name" {
  type = string 
  default = "ethicalhackingmssql2"
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

variable "mssql-admin-user" {
  type = string
  default = "mssqladmin"
}

variable "mssql-admin-passowrd" {
  type = string
  default = "MSSQLPassword123!"
}
