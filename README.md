# aks-sysdig
Terraform template for creating an AKS cluster with Sysdig

Read:
- [https://developer.hashicorp.com/terraform/tutorials/azure/aks](https://developer.hashicorp.com/terraform/tutorials/azure/aks)
- [https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [https://github.com/hashicorp/terraform-provider-azurerm/tree/main/examples/kubernetes](https://github.com/hashicorp/terraform-provider-azurerm/tree/main/examples/kubernetes)
- [https://github.com/Azure/AKS-Landing-Zone-Accelerator/tree/main/Scenarios/AKS-Secure-Baseline-PrivateCluster/Terraform](https://github.com/Azure/AKS-Landing-Zone-Accelerator/tree/main/Scenarios/AKS-Secure-Baseline-PrivateCluster/Terraform)
- [https://github.com/Azure/Aks-Construction](https://github.com/Azure/Aks-Construction)
- [https://docs.nubesgen.com/getting-started/terraform/](https://docs.nubesgen.com/getting-started/terraform/)
- [https://docs.sysdig.com/en/docs/installation/sysdig-monitor/install-sysdig-agent/kubernetes/#installation](https://docs.sysdig.com/en/docs/installation/sysdig-monitor/install-sysdig-agent/kubernetes/#installation)
- [https://grafana.com/tutorials/k8s-monitoring-app/](https://grafana.com/tutorials/k8s-monitoring-app/)

- [https://sysdig.com/company/free-trial-platform/](https://sysdig.com/company/free-trial-platform/)
- [Inspecting all the details of your environment with Kubernetes context](https://www.youtube.com/watch?v=y0XvIC2TJFg)
- [Scanning for vulnerabilities in your CI/CD pipelines, registries and at runtime(https://www.youtube.com/watch?v=u4cAdd0dlsA)
- [Validating compliance against PCI, NIST, etc.](https://www.youtube.com/watch?v=KqcK-4s-gSY)
- [Detecting and responding to threats with OOB rules (MITRE, FIM, etc.)](https://www.youtube.com/watch?v=uCkTLatNKOo)


```sh
az extension add --name amg
az extension add --name aks-preview
az extension update --name aks-preview

az feature list --output table --namespace Microsoft.ContainerService

az feature register --namespace "Microsoft.ContainerService" --name "AKS-PrometheusAddonPreview" 
az feature register --namespace "Microsoft.ContainerService" --name "AKS-VPAPreview"
az feature register --namespace "Microsoft.ContainerService" --name "AutoUpgradePreview"
az feature register --namespace "Microsoft.ContainerService" --name "AKS-OMSAppMonitoring"
az feature register --namespace "Microsoft.ContainerService" --name "ManagedCluster"

az feature register --namespace "Microsoft.ContainerService" --name "EnableAPIServerVnetIntegrationPreview" 
az feature register --namespace "Microsoft.ContainerService" --name "AKS-GitOps"
az feature register --namespace "Microsoft.ContainerService" --name "EnableWorkloadIdentityPreview"
az feature register --namespace "Microsoft.ContainerService" --name "AKS-Dapr"
az feature register --namespace "Microsoft.ContainerService" --name "EnableAzureKeyvaultSecretsProvider"
az feature register --namespace "Microsoft.ContainerService" --name "AKS-AzureDefender"
az feature register --namespace "Microsoft.ContainerService" --name "AKS-AzurePolicyAutoApprove"
az feature register --namespace "Microsoft.ContainerService" --name "FleetResourcePreview"

az provider list --output table
az provider list --query "[?registrationState=='Registered']" --output table
az provider list --query "[?namespace=='Microsoft.KeyVault']" --output table
az provider list --query "[?namespace=='Microsoft.OperationsManagement']" --output table

az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.Kubernetes 
az provider register --namespace Microsoft.KubernetesConfiguration
az provider register --namespace Microsoft.Kusto
az provider register --namespace Microsoft.Dashboard
az provider register --namespace Microsoft.ManagedIdentity
az provider register --namespace Microsoft.Monitor
az provider register --namespace Microsoft.OperationsManagement
az provider register --namespace Microsoft.Network  

az provider register --namespace Microsoft.Compute 
az provider register --namespace Microsoft.ContainerRegistry
az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.OperationalInsights 
az provider register --namespace Microsoft.KeyVault
az provider register --namespace Microsoft.DBforPostgreSQL
az provider register --namespace Microsoft.DBforMySQL
az provider register --namespace Microsoft.AppConfiguration       
az provider register --namespace Microsoft.AppPlatform
az provider register --namespace Microsoft.EventHub  

az provider register --namespace Microsoft.ServiceBus
az provider register --namespace Microsoft.Storage
az provider register --namespace Microsoft.Subscription

# https://learn.microsoft.com/en-us/azure/aks/cluster-extensions
az extension add --name k8s-extension
az extension update --name k8s-extension

# https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/tutorial-use-gitops-flux2?
az extension add -n k8s-configuration

```


```sh
find . -type f -print0 | xargs -0 dos2unix
bash 00_bootstrap/commands.sh 

%windir%\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File deploy.ps1
powershell.exe -ExecutionPolicy Bypass -File deploy.ps1

```