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
## Pip (for installing Ansible collections)
```
sudo apt install python3-pip
```

## Azure Collection for Ansible
```
ansible-galaxy collection install azure.azcollection
```
This collection has dependancies of its own. Navigate into the collection (default: ~/.ansible/collections/ansible_collections/azure/azcollection/) and then use pip to install those dependancies
```
pip install -r requirements-azure.txt
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

# Ansible Dynamic Inventory
The dynamic invetory filename must end in 'azure_rm' and must be a .yml or .yaml file. 

# Running Terraform
Terraform must first be initialized, which creates and stores the state in the remote backend. You can create a plan and store it in a plan file using the `-out` command. Plan files may also contain secrets. 

To execute the plan, run `terraform apply` on the plan file.
```
terraform init
terraform plan -out="tfplan.plan"
terraform apply tfplan.plan
```
You can modify the `vars.tf` file, or override them with a file ending in `.tfvars` file to change variables. You can also pass them in through the command line using the `-var 'NAME=VALUE'` option.

# Pros & Cons for Terraform as the Initiator with a Dynamic Inventory
* Pros
    - Resource group for dynamic inventories is guaranteed to be created before ansible is run, allowing immediate configuration
    - Output is displayed without having to make any changes


* Issues
    -  Ansible is not run unless there is a change in state. However, using a timestamp trigger will get it to run on every apply. This causes the "resource" to be destroyed and then recreated.