prefix = "lzaks-hub-weu"

tenant_id_hub       = "xxxxxxzz-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
subscription_id_hub = "xxxxxxzz-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

tenant_id_spoke       = "xxxxxxzz-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
subscription_id_spoke = "xxxxxxzz-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

resources_location = "westeurope" # "francecentral" # "westcentralus" # 

cidr_vnet_hub        = ["172.16.0.0/16"]
cidr_subnet_firewall = ["172.16.0.0/26"]
cidr_subnet_bastion  = ["172.16.1.0/27"]
cidr_subnet_vm       = ["172.16.2.0/26"]

enable_bastion  = true
enable_firewall = false

enable_vm_jumpbox_linux = true
enable_vm_jumpbox_windows = false