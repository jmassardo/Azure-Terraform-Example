# Azure-Terraform-Example
This is a simple example for how to provision a single machine in [Terraform](https://www.terraform.io) using [Microsoft Azure](https://portal.azure.com). I'm not going to provide detailed steps as there are a number of existing sites with excellent steps. I will, however, reference these sites and provide links.

Please feel free to submit issues (or better yet, PRs) if you see something that I can improve.

## Setup

I personally find it difficult to read through an extremely long config file so I break them up like this:
* Terraform plan
    * AzureCredentials.tf
    * AzureInfrastructure.tf
    * Environment
        * Server1.tf
        * Server2.tf
        * etc

There are many ways to organize the files, this makes sense to me. (Although the idea isn't directly mine, I borrowed it from [These guys](https://blog.gruntwork.io/how-to-manage-terraform-state-28f5697e68fa). Next we'll look at each file.

### AzureCredentials.tf
The first task is to get the required information and credentials from Azure. I used Microsoft's [walk-through](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure).
You will need the following:
```
  subscription_id = "...."
  client_id       = "...."
  client_secret   = "...."
  tenant_id       = "...."
```
I separated the credentials out into a separate file so I could exclude them from my git repos. In a production instance, I would use another vaulting mechanism to manage these secrets along with any other secrets like the root or local admin password.

### AzureInfrastructure.tf
I put these items in a separate file because they are shared among all the virtual machines in the environment. This includes things such as:
* [Resource Groups](https://www.terraform.io/docs/providers/azurerm/r/resource_group.html)
* [Virtual Networks](https://www.terraform.io/docs/providers/azurerm/r/virtual_network.html)
* [Subnets](https://www.terraform.io/docs/providers/azurerm/r/subnet.html)
* [Network Security Groups](https://www.terraform.io/docs/providers/azurerm/r/network_security_group.html)
* [Security Rules](https://www.terraform.io/docs/providers/azurerm/r/network_security_rule.html)
* Etc.

### <%SERVERNAME%>.tf
Create a separate file for each server needed for the build-out. This file contains the specific details about the server including the public IP (if needed), network interface configuration, the VM size, required OS, hostname, etc.

* [Public IP](https://www.terraform.io/docs/providers/azurerm/r/public_ip.html)
* [Network Interface](https://www.terraform.io/docs/providers/azurerm/r/network_interface.html)
* [Virtual Machine](https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html)

This file is also used to run commands/scripts. This is called Provisioning in Terraform. There are multiple provisioners but these are the most relevant to me.

* [Chef](https://www.terraform.io/docs/provisioners/chef.html)
* [Local Execution](https://www.terraform.io/docs/provisioners/local-exec.html)
* [Remote Execution](https://www.terraform.io/docs/provisioners/remote-exec.html)

One  thing to keep in mind with these provisioner is the Local execution tasks run locally on the system were Terraform is being run. Remote execution tasks are remotely executed on the target system being created.