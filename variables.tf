# Note: You must set the environment variables for "TF_VAR_SUBSCRIPTION_ID"

variable "SUBSCRIPTION_ID" { # should be overriden by environment variable
    type = string
    default = "[subscription_id]"
}

variable "kali-user" {
    type = string
    default = "kali"
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