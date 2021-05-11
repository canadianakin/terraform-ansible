terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.58.0"
    }
  }

# Comment this block out for local state. Setup is required for remote state
  backend "azurerm" {
    resource_group_name  = "terraform-state"
    storage_account_name = "tfansiblestorageakin"
    container_name       = "terraform-state-container"
    key                  = "viaterraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "vt-demo" {
  name     = "via-terraform"
  location = var.location
}

resource "local_file" "hosts" {
    content = <<EOF
[vm]
${data.azurerm_public_ip.vt-demo-ip-data.ip_address}

[vm:vars]
ansible_become=true
ansible_user=adminuser
EOF
    filename = "./hoststest"

    provisioner "local-exec" {
        command = "ansible-playbook -i hoststest nginx_playbook.yml"
    }
}