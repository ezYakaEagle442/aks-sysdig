cd .\01_management
rm terraform.tfstate
rm terraform.tfstate.backup

terraform init # -upgrade
# terraform refresh
terraform plan -out tfplan
terraform apply tfplan

echo "###################################"
echo "### 01_management completed       #"
echo "###################################"

#cd ..\02_hub
#rm terraform.tfstate
#rm terraform.tfstate.backup

#terraform init # -upgrade
#terraform plan -out tfplan
#terraform apply tfplan

cd ..\03_spoke_aks_infra
rm terraform.tfstate
rm terraform.tfstate.backup

terraform init # -upgrade
# terraform refresh
terraform plan -out tfplan
terraform apply tfplan

echo "###################################"
echo "### 03_spoke_aks_infra completed  #"
echo "###################################"

cd ..\04_spoke_aks_cluster
rm terraform.tfstate
rm terraform.tfstate.backup

terraform init # -upgrade
# terraform refresh
terraform plan -out tfplan
terraform apply tfplan

echo "###################################"
echo "### 04_spoke_aks_cluster completed#"
echo "###################################"

#cd ..\05_monitoring
#rm terraform.tfstate
#rm terraform.tfstate.backup

#terraform init # -upgrade
## terraform refresh
#terraform plan -out tfplan
#terraform apply tfplan