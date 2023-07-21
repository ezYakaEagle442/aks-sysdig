prefix = "lzaks"

tenant_id_hub       = "xxxxxxzz-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
subscription_id_hub = "xxxxxxzz-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

tenant_id_spoke       = "xxxxxxzz-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
subscription_id_spoke = "xxxxxxzz-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

resources_location = "westeurope" # "francecentral" # "westcentralus" # "northeurope" # 

kubernetes_version   = "1.27.1" # "1.26.3" # "1.26.0"
aad_group_aks_admins = "aad_group_aks_admins"

cidr_subnet_nodes             = ["10.1.3.0/24"]
cidr_subnet_apiserver_vnetint = ["10.1.4.0/28"]
cidr_subnet_pods              = ["10.1.240.0/20"]

cidr_aks_service   = "10.0.0.0/16"
aks_dns_service_ip = "10.0.0.10"
aks_outbound_type  = "loadBalancer" # "userDefinedRouting" # "userAssignedNATGateway" # "loadBalancer" , userDefinedRouting, managedNATGateway

aks_network_plugin  = "azure" # "kubenet", "none"
network_plugin_mode = "overlay"

enable_app_gateway = false # true

enable_private_cluster                      = false
enable_apiserver_vnet_integration           = true
enable_nodepool_apps                        = true
enable_nodepool_spot                        = false
enable_system_nodepool_only_critical_addons = false
enable_aks_admin_group                      = false
enable_aks_admin_rbac                       = true

enable_grafana_prometheus = true
enable_monitoring         = false

# integration with Hub network
enable_hub_spoke    = false
enable_firewall     = false
enable_vnet_peering = false
