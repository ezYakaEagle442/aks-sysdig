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
- [https://docs.sysdig.com/en/docs/installation/configuration/sysdig-agent/understand-the-agent-configuration/](https://docs.sysdig.com/en/docs/installation/configuration/sysdig-agent/understand-the-agent-configuration/)


```sh
az config set extension.use_dynamic_install=yes_without_prompt

az extension add --name amg
az extension add --name aks-preview
az extension update --name aks-preview

az feature list --output table --namespace Microsoft.ContainerService

az feature register --namespace "Microsoft.ContainerService" --name "AKS-PrometheusAddonPreview"

az feature register --namespace "Microsoft.ContainerService" --name "NetworkObservabilityPreview" 

az feature show --namespace "Microsoft.ContainerService" --name "NetworkObservabilityPreview"

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

Install [KubeLogin](https://github.com/Azure/kubelogin) on Linux/WSL2
```sh
# https://azure.github.io/kubelogin/install.html
# https://azure.github.io/kubelogin/concepts/login-modes/azurecli.html
# https://azure.github.io/kubelogin/concepts/login-modes/sp.html
KUBE_LOGIN_VERSION="v0.0.31"
wget https://github.com/Azure/kubelogin/releases/download/$KUBE_LOGIN_VERSION/kubelogin-linux-amd64.zip
chmod +x ./kubelogin-linux-amd64.zip
unzip kubelogin-linux-amd64.zip
sudo mv ./bin/linux_amd64/kubelogin /usr/local/bin/kubelogin
kubelogin --version
rm -R ./bin
```

Install KubeLogin with PowerShell
```sh
az aks install-cli
$targetDir="$env:USERPROFILE\.azure-kubelogin"
$oldPath = [System.Environment]::GetEnvironmentVariable("Path","User")
$oldPathArray=($oldPath) -split ";"
if(-Not($oldPathArray -Contains "$targetDir")) {
    write-host "Permanently adding $targetDir to User Path"
    $newPath = "$oldPath;$targetDir" -replace ";+", ";"
    [System.Environment]::SetEnvironmentVariable("Path",$newPath,"User")
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","User"),[System.Environment]::GetEnvironmentVariable("Path","Machine") -join ";"
}

```

Deploy a sample application into your cluster in one new namespace.
As an example, you can any of the following examples:
[https://github.com/dockersamples/example-voting-app]
[https://github.com/GoogleCloudPlatform/microservices-demo]
[https://github.com/microservices-demo/microservices-demo]

The vote web app is then available on port 31000 on each host of the cluster, the result web app is available on port 31001.

```sh
#https://github.com/dockersamples/example-voting-app/tree/main

NS_APP="apps"
kubectl create namespace ${NS_APP}
kubectl label namespace/${NS_APP} purpose=sysdig
kubectl describe namespace ${NS_APP}

cd example-voting-app
kubectl apply -f k8s-specifications/ -n ${NS_APP}

kubectl get nodes -o wide
kubectl get deployment -o wide -n ${NS_APP}
kubectl get pods -o wide -n ${NS_APP}
kubectl get svc -o wide -n ${NS_APP}

# https://learn.microsoft.com/en-us/azure/aks/use-node-public-ips

# az aks nodepool update -g rg-lzaks-spoke-aks-nodes --cluster-name aks-lzaks-cluster -n aks-poolappsamd-41974831-vmss --enable-node-public-ip

# az vmss list-instance-public-ips -g rg-lzaks-spoke-aks-nodes -n aks-poolappsamd-41974831-vmss 

# kubectl port-forward deployment/vote 8040:31000 -n ${NS_APP}
# kubectl port-forward deployment/result 8042:31001 -n ${NS_APP}

```

# Install the Sysdig Agent

```sh

helm version
helm repo update

# PROMETHEUS & GRAFANA
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade --install prom prometheus-community/kube-prometheus-stack -n monitoring --create-namespace `
       --set grafana.adminUser="grafana" --set grafana.adminPassword="@Aa123456789"
start powershell {kubectl port-forward service/prom-grafana 8000:80 -n monitoring}
start microsoft-edge:http://localhost:8000
# Access dashboard: http://localhost:8000
# login: grafana, password: @Aa123456789

# https://sysdig.com/company/free-trial-platform/ https://sysdig.com/start-free/
# Make sure to select all options to have access to Sysdig Monitor and Sysdig Secure

# Sysdig: https://docs.sysdig.com/en/docs/installation/sysdig-monitor/install-sysdig-agent/kubernetes/#installation
helm repo add sysdig https://charts.sysdig.com
helm repo update
helm repo list
kubectl top nodes

# kubectl create ns sysdig-agent

# https://docs.sysdig.com/en/docs/administration/saas-regions-and-ip-ranges/#european-union eu1 in Germany

helm install sysdig-agent --namespace sysdig-agent --create-namespace \
    --set global.sysdig.accessKey=<ACCESS_KEY> \
    --set global.sysdig.region=eu1 \
    --set nodeAnalyzer.secure.vulnerabilityManagement.newEngineOnly=true \
    --set global.kspm.deploy=true \
    --set nodeAnalyzer.nodeAnalyzer.benchmarkRunner.deploy=false \
    --set global.clusterConfig.name=<CLUSTER_NAME> \
    sysdig/sysdig-deploy

helm ls -n sysdig-agent
kubectl get pods -n sysdig-agent

```


# Monitor

Verify the application status via Kubernetes Advisor, anything to highlight?

Use PromQL Explorer to create some queries using metrics coming from or
related with the Voting app (or the application you have chosen)

i. One query needs to represent the cpu usage of each pod of the Voting
app namespace (sysdig_container_cpu_cores_used)

```sh
sysdig_container_cpu_cores_used{cluster="aks-lzaks-cluster"}
```

ii. Other query needs to represent % the CPU Used
(sysdig_container_cpu_cores_used) vs the CPU Requested
(kube_pod_container_resource_requests{resource=”cpu”}) for the Voting
app pods

```sh

```


iii. If you can’t build these 2 queries, you can use other a similar query
c. Use the queries you have built to create a new dashboard
d. Use the queries you have built to create an alert related with the Voting
application


# Secure

Review the vulnerabilities that are appearing in the Voting application

Define a Kubernetes CIS benchmark to your cluster
i. What conclusions can you extract from the results?
c. Enable some Runtime Policies and trigger some of them
i. We recommend triggering “Terminal Shell in a Container” rule “Sysdig
Runtime Notable Events” by accessing a container running in the cluster
ii. You can select other policies/rules to trigger

Investigate Sysdig API via Swagger definition

The query should look something like:
https://<sysdig region API>/api/scanning/runtime/v2/workflows/results?cursor&filter=kubernetes.namespace.name%20%3D%20%22<namespace>%22&limit=100&order=desc&sort=runningVulnsBySev

a. Select one image from the Voting application (or the application you have
deployed) and extract via API all vulnerabilities associated with that image
i. Show us the API call(s) you have used to extract that information
ii. You can use curl, a script in bash/python, postman…

[https://eu1.app.sysdig.com/api/public/docs/index.html](https://eu1.app.sysdig.com/api/public/docs/index.html)
[https://eu1.app.sysdig.com/#/login](https://eu1.app.sysdig.com/#/login)


[ Retrieve the Sysdig API Token](https://docs.sysdig.com/en/docs/developer-tools/sysdig-python-client/getting-started-with-sdcclient/#retrieve-the-sysdig-api-token)
```sh

```