# aws-three-tier-architecture
Designing a three tier architecture in AWS using Terraform

## Architecture



## Prerequisites

Before using this Terraform code, ensure you have the following set up:

- **AWS CLI**: Install the AWS CLI. [Follow the installation guide here](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
- **Terraform**: Install Terraform. [Installation instructions can be found here](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).
- **AWS IAM User**: Create an AWS IAM user with the necessary permissions. Ensure you have the Access Key and Secret Access Key. [Learn more about IAM User and security best practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html). It's recommended to use an IAM user with the least privilege necessary for the tasks.


## Installation
Follow these steps to set up and use the Terraform configuration:

1.  **Copy Configuration File**: Copy the `terraform.tfvars.sample` file and rename it to `terraform.tfvars`. 


2. **Configure AWS CLI**: Run the following command to configure the AWS CLI with your credentials: 
```shell
 aws configure
```
Enter your AWS Access Key, Secret Access Key, and default region.


3. Initialize Terraform: Apply the Terraform configuration to create the resources:
```shell
terraform init
```

4. Apply Terraform Configuration:  
```shell
terraform apply
```
Review the plan and type yes to proceed.

5. Delete All Resources: To remove all resources managed by this Terraform configuration:
```shell
terraform destroy
```
⚠️ Warning: This will permanently delete all resources created by Terraform.