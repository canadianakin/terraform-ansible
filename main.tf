terraform {
  required_version = ">=0.15.3"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.58.0"
    }
    local = {
      source = "hashicorp/local"
      version = ">=2.1.0"
    }
    null = {
      source = "hashicorp/null"
      version = ">=3.1.0"
    }
  }

# Comment this block out for local state. Setup is required for remote state
  backend "azurerm" {
    resource_group_name  = "terraform-state"
    storage_account_name = "tfansiblestorageakin"
    container_name       = "terraform-state-container"
    key                  = "dynamicterraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "dt-demo" {
  name     = "dynamic-terraform"
  location = var.location
}

#local-exec requires a resource to run in, and I am making it depend on the ip address so that it is run after the vm is accessible 
resource "null_resource" "ansible" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
        command = "ansible-playbook -i ${var.inventory} ${var.playbook }"
    }
    depends_on = [data.azurerm_public_ip.dt-demo-ip-data1, data.azurerm_public_ip.dt-demo-ip-data2]
}