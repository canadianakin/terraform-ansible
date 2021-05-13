# Terraform-Ansible
This repo is for testing various configurations and integrations of Ansible and Terraform. The end goal is to display the nginx start page when navigating to the IP address.

# Using Ansible as the Main Initiator
This method requires a few extra steps.
- Terraform plugin for Ansible, which is a community maintained package
- Inventory needs to be populated before running, otherwise it must be run again
- More configuration for outputs, documentation on terraform plugin is unclear here how to display plan information or defined outputs.

To run this example, you will need the following prerequisites:

1. Azure CLI
2. Terraform
3. Ansible
5. Community Collection for Ansible

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
## Community Collection for Ansible
The Terraform plugin for Ansible is part of this collection. It appears as though the entire collection needs to be installed for it to operate. 
```
ansible-galaxy collection install community.general
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

# Running Ansible
Terraform must first be initialized, which creates and stores the state in the remote backend. You can then run the playbook, specifying the dynamic inventory and passing in the state you would like for Terraform. 

- `present` is equivalent to `terraform apply --auto-approve`.
- `absent` is equivalent to `terraform destroy`.
- `planned` is equivalent to `terraform plan`, however you must also provide a plan file by passing another variable eg: `plan_file=tfplan.plan`. 
```
terraform init
ansible-playbook -i hosts nginx_playbook.yml -e state="present"
```
You can modify the `vars.tf` file, or override them with a file ending in `.tfvars` file to change variables. 

# Clean Up
Destroy the resources you've created. You should also manually destroy the storage container you've created for the remote state in the Azure portal.
```
ansible-playbook -i myazure_rm.yml nginx_playbook.yml -e state="absent"
```

# Pros & Cons for Ansible as the Initiator with a Dynamic Inventory
I do not see this implementation being the best option, at least for this use case. It may be a better option for a different scenario, but I can not think of one at the moment.
## Pros
- Single command to run both tools. 
- Slightly easier to run with different playbooks & inventories compared to Terraform method

## Cons
- The inventory does not initialize until Terraform runs the first time.
    - IE: on the first run, there is no inventory and is only populated on subsequent runs.
    - Needs to be executed twice for the initial run to populate inventory.
    - New hosts could be manually added to the host file, but the goal is automation. Having Terraform create the host file when vms are created feels like a bandaid fix.
- Difficulty running Ansible independantly from Terraform when desired. 
- The community collection for Ansible is maintained by the community, which may have implications for stability and security. 
- The host file is deleted and generated each run. This could cause some issues! Especially when scaled up.