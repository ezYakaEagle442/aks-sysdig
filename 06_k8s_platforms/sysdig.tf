# https://eu1.app.sysdig.com/secure/#/onboarding/user-profile/cloud/2

# Prerequisites
# Contributor Azure role assignment
#Terraform (version 1.3.1+) installed on the machine from which you will deploy the installation code
# Or connect an entire Tenant instead.

#Deploy with Terraform
#This Terraform deployment will create a lighthouse definition  and the resources  required to process cloud logs.
#Subscription ID
#Copy the following and save it to a file named “main.tf”

terraform {
  required_providers {
    sysdig = {
      source = "sysdiglabs/sysdig"
    }
  }
}

provider "sysdig" {
  sysdig_secure_url       = "https://eu1.app.sysdig.com"
  sysdig_secure_api_token = "c4ce3024-2231-48ae-8ed6-df13b2999623"
}

provider "azurerm" {
  features { }
  subscription_id = ""
}

module "single-subscription" {
  source = "sysdiglabs/secure-for-cloud/azurerm//examples/single-subscription"
}

# terraform init && terraform apply

