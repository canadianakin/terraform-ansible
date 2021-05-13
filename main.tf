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

resource "local_file" "public_ips" {
      content = <<EOF
${data.azurerm_public_ip.dt-demo-ip-data.ip_address}
EOF

    filename = "./public_ips"

    provisioner "local-exec" {
        command = "ansible-playbook -i myazure_rm.yml nginx_playbook.yml"
    }
}