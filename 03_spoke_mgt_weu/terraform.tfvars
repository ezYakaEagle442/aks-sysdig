prefix = "lzaks-spoke-mgt-weu"

tenant_id_hub       = "777666zz-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
subscription_id_hub = "777666zz-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

tenant_id_spoke       = "777666zz-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
subscription_id_spoke = "777666zz-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

resources_location = "westeurope" # "francecentral" # "westcentralus" # 

cidr_vnet_spoke_mgt = ["10.2.0.0/16"]
cidr_subnet_mgt     = ["10.2.0.0/24"]

enable_vm_jumpbox_windows = true
enable_vm_jumpbox_linux   = true

# integration with Hub & Firewall
enable_firewall     = false
enable_vnet_peering = true