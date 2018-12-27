# STIG Automation using Chef on AWS and Azure

### Introduction
The Defense Information Systems Agency (DISA) provides a standard to maintaining the security posture of the Department of Defense (DoD) IT infrastructure.  DISA accomplishes this task is by developing and using Security Technical Implementation Guides, or “STIGs.”

DISA Security Technical Implementation Guides (STIGs) for Windows OS:
	```https://iase.disa.mil/stigs/os/windows/Pages/index.aspx```

STIGs are nothing more than alternate configurations that make commonly used applications more secure.  All DoD IT assets must meet STIG compliance in some fashion before they are allowed to operate on DoD networks.  The purpose of STIGs are obvious; default configurations for many applications are inadequate in terms of security, and therefore DISA felt that developing a security standard for these applications would allow various DoD agencies
to utilize the same standard – or STIG – across all application instances that exist.

###  Solution

STIG automation solution implemented in this repo using the Chef.  Mainly using Chef templates with dynamically generating attributes (based on the STIG rules provide in .yml file) to generate the desired configuration files based on the STIG rules.  Finally, desired security configuration is applied on the Windows OS. 

### Development Environment Setup
 - Install [ChefDK](https://docs.chef.io/install_dk.html)
 - For AWS:
	 - Install the [AWS command line tools](https://docs.aws.amazon.com/cli/latest/userguide/installing.html).
	 - Run `aws configure`. This will set up your AWS credentials for both the AWS CLI tools and kitchen-ec2.
	 - Create the required entries for kitchen.yml on AWS portal to create/converge an EC2 instance and update the below kitchen.yml file for AWS
 - For Azure:
	 - Install the [kitchen-azurerm](https://github.com/test-kitchen/kitchen-azurerm) driver on your workstation manually and update the below kitchen.yml file for Azrue

###  kitchen.yml for AWS
```
driver:
	name: ec2
	region: us-east-1
	availability_zone: f
	subnet_id: subnet-your-subnet-id
	security_group_ids: ["sg-your-sg1"]
	aws_ssh_key_id: your-ssh-key
	iam_profile_name: your-iam-role
	instance_type: t2.micro
	image_id: ami-your-ami-id
	user_data: .user_data_windows.ps1
	require_chef_omnibus: true
	associate_public_ip: true
	retryable_tries: 120
	tags:
		Name: ec2-kitchen-windows-vm
		Owner: VeeVee
		Environment: AWS
		Project: Windows 2012 STIG Automation

provisioner:
	name: chef_zero

verifier:
	name: inspec

transport:
	ssh_key: ~/.ssh/your.pem

platforms:
	- name: windows-2012r2
	  transport:
		name: winrm
		user: Administrator
		password: 'password@123'

suites:
	- name: default
	  run_list:
		- recipe[Windows_2012_MS_STIG::security_policies]
	  attributes:
```
###  kitchen.yml for Azure
	driver:
		name: azurerm
		subscription_id: 'your-azure-subscription-id'
		location: 'East US'
		machine_size: 'Standard_D1'
		tags:
			Name: kitchen-windows-vm
			Owner: VeeVee
			Environment: Azure
			Project: Windows 2012 STIG Automation
	provisioner:
		name: chef_zero
	verifier:
		name: inspec
	platforms:
		- name: windows-2012r2
		  driver:
			image_urn: MicrosoftWindowsServer:WindowsServer:2012-R2-Datacenter:latest
		  transport:
			name: winrm
	suites:
		- name: default
		  run_list:
			- recipe[Windows_2012_MS_STIG::security_policies]

###  Apply cookbook on AWS or Azure using Test Kitchen
`Test Kitchen enables us to run cookbooks in a temporary environment that resembles production. With Test Kitchen, we confirm that things are working before we deploy  code to a test, preproduction, or production environment.`

- Below is the Test Kitchen workflow to test cookbooks
	- `kitchen create` - creates an instance of virtual environment, for example, a Windows Server virtual machine.
	- `kitchen converge` - applies cookbook to the virtual environment.
	- `kitchen login` - connect to virtual environment, typically over Remote Desktop or WinRM.
	- `kitchen verify` - manually verify that virtual environment is configured as expected.
	- `kitchen destroy` - shuts down and destroys virtual environment.