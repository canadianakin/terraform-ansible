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
  default = "dt-demo"
}

variable "inventory" {
  type = string
  default = "azure_rm.yml"
}

variable "playbook" {
  type = string
  default = "nginx_playbook.yml"
}