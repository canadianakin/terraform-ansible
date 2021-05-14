# Terraform-Ansible
This repo is for testing various configurations and integrations of Ansible and Terraform. The end goal is to display the nginx start page when navigating to the IP address.

To run, you will need the following prerequisites:

1. Azure CLI
2. Terraform
3. Ansible
4. Azure Collection for Ansible

This project also uses a remote state file for Terraform. You can remove the backend in `main.tf` for a local state, or create a resource before performing a terraform init. Be wary, the state file may contain secrets. 

# Installing Prerequisites

## Azure CLI
```
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az login
```

## Terraform
```
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt update && sudo apt install terraform
terraform -install-autocomplete
```

## Ansible
```
sudo apt update && sudo apt install -y ansible
```

# Terraform Remote State

To set up a storage location, you can create one with this command. `terraform-state` is the resource group name. `STORAGE_NAME` needs to be unique, so name it something like `yourNameStateStorage`. 

Look up storage pricing on Azure for different storage types and costs.
```
az storage account create -g terraform-state -l eastus \
  --name STORAGE_NAME \
  --sku Standard_LRS \
  --encryption-services blob
```

# Running Terraform
Terraform must first be initialized, which creates and stores the state in the remote backend. You can create a plan and store it in a plan file using the `-out` command. Plan files may also contain secrets. 

To execute the plan, run `terraform apply` on the plan file.
```
terraform init
terraform plan -out="tfplan.plan"
terraform apply tfplan.plan
```
You can modify the `vars.tf` file, or override them with a file ending in `.tfvars` file to change variables. You can also pass them in through the command line using the `-var 'NAME=VALUE'` option.

# Clean Up
Destroy the resources you've created. You should also manually destroy the storage container you've created for the remote state in the Azure portal.
```
terraform destroy
```

# Pros & Cons for Terraform as the Initiator with a Dynamic Inventory
This seems like the preferable implementation for Azure. The ability to override the playbook and inventory location variables gives it essentially the same utility as using Ansible as the initiator. There is less complexity for this example. As projects scale up, that may not be the case, but I think that alternate methods will suffer similarly.

## Pros
- Output is displayed cleanly
- Variables may not need to be passed through the command line (at least for this example)
- If desired, resources can be targeted using different playbooks
- Less required modules & collections.
- Ansible will always run the first time

## Cons
- Ansible playbooks and inventories should be stored in a variables file or passed as variables in the command line. This is not exactly a con, but it could be annoying with a lot of different playbooks and/or inventories. 