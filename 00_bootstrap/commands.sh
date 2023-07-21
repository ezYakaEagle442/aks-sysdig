# create Service Principal

# create Storage Account for Terraform state file

REGION=westeurope
STORAGEACCOUNTNAME=statfs
CONTAINERNAME=akssysdigtfstate
TFSTATE_RG=rg-tfstate

az group create --name $TFSTATE_RG --location $REGION

az storage account create -n $STORAGEACCOUNTNAME -g $TFSTATE_RG -l $REGION --sku Standard_LRS

az storage container-rm create --storage-account $STORAGEACCOUNTNAME --name $CONTAINERNAME

