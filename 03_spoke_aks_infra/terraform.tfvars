prefix = "lzaks-spoke-aks-infra"

tenant_id_hub       = "xxxxxxzz-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
subscription_id_hub = "xxxxxxzz-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

tenant_id_spoke       = "xxxxxxzz-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
subscription_id_spoke = "xxxxxxzz-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

resources_location   = "westeurope" # "francecentral" # "westcentralus" # 

acr_name                                    = "acrakssysdig042"
keyvault_name                               = "kv-aks-sysdig-042"
storage_account_name                        = "staakssysdig042"

cidr_vnet_spoke_aks      = ["10.1.0.0/16"]
cidr_subnet_appgateway   = ["10.1.1.0/24"]
cidr_subnet_spoke_aks_pe = ["10.1.2.0/28"]

enable_grafana_prometheus = true
enable_app_gateway        = false
enable_keyvault           = true
enable_storage_account    = true
enable_private_keyvault   = false
enable_private_acr        = false

enable_monitoring = true

# integration with Hub & Firewall
enable_hub_spoke    = false
enable_firewall     = false
enable_vnet_peering = false
