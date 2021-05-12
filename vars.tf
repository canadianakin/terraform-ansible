# These variables can be overridden by a *.tfvars file

variable "location" {
  type    = string
  default = "eastus"
}

variable "ssh-source-address" { # Override this to only allow access from specified ip
  type    = string
  default = "*"
}

variable "prefix" {
  type    = string
  default = "va-demo"
}