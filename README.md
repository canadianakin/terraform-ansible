# terraform-ansible
Testing various configurations and integrations of Ansible and Terraform

# Using Ansible as the main initiator
This method requires a few extra steps.
* Terraform plugin for Ansible, which is a community maintained package
* Likely needs a dynamic inventory, as the host ip addresses are not known at the start of the playbook
* - dynamic inventory requires installation of azure collection https://galaxy.ansible.com/azure/azcollection
* More configuration for outputs, I still need to look into this

# Issues
* The dynamic inventory does not initialize until it has a resource to link to
- ie: on the first run, there is no inventory and is only populated on subsequent runs
- this issue would not be present if terraform were to call ansible, because vms would be provisioned 1st
