# terraform-ansible
Testing various configurations and integrations of Ansible and Terraform

* Pros
- Resource group for dynamic inventories is guaranteed to be created before ansible is run, allowing immediate configuration
- Output is displayed without having to make any changes
- 

* Issues
-  Ansible is not run unless there is a change in state. However, using a timestamp trigger will get it to run on every apply. This causes the "resource" to be destroyed and then recreated.