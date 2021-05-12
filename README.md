# terraform-ansible
Testing various configurations and integrations of Ansible and Terraform

# Using Ansible as the main initiator
This method requires a few extra steps.
* Terraform plugin for Ansible, which is a community maintained package
* Likely needs a dynamic inventory, as the host ip addresses are not known at the start of the playbook
* More configuration for outputs, I still need to look into this
