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
- [Scanning for vulnerabilities in your CI/CD pipelines, registries and at runtime](https://www.youtube.com/watch?v=u4cAdd0dlsA)
- [Validating compliance against PCI, NIST, etc.](https://www.youtube.com/watch?v=KqcK-4s-gSY)
- [Detecting and responding to threats with OOB rules (MITRE, FIM, etc.)](https://www.youtube.com/watch?v=uCkTLatNKOo)
- [https://docs.sysdig.com/en/docs/installation/configuration/sysdig-agent/understand-the-agent-configuration/](https://docs.sysdig.com/en/docs/installation/configuration/sysdig-agent/understand-the-agent-configuration/)


## Setup AZ CLI
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

## Setup Kube Login When AAD RBAC is enabled
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


## Install TerraForm on Linux/WSL2

```sh
# https://developer.hashicorp.com/terraform/downloads
TF_VERSION="1.5.3"
wget https://releases.hashicorp.com/terraform/$TF_VERSION/terraform_${TF_VERSION}_linux_amd64.zip -O terraform.zip;
chmod +x ./terraform.zip
unzip terraform.zip
sudo mv ./terraform /usr/local/bin/terraform
terraform -v
rm terraform.zip
```


# Deploy AKS Cluster

```sh
# find . -type f -print0 | xargs -0 dos2unix
bash 00_bootstrap/commands.sh 

%windir%\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File deploy.ps1
powershell.exe -ExecutionPolicy Bypass -File deploy.ps1

az aks get-credentials -g rg-lzaks-spoke-aks-cluster --name aks-lzaks-cluster
kubectl cluster-info

```

## Setup K8S Alias

```sh
source <(kubectl completion bash) # setup autocomplete in bash into the current shell, bash-completion package should be installed first.
echo "source <(kubectl completion bash)" >> ~/.bashrc 
alias k=kubectl
complete -F __start_kubectl k

alias kn='kubectl config set-context --current --namespace '

export gen="--dry-run=client -o yaml"
# ex: k run nginx --image nginx $gen

# Get K8S resources
alias kp="kubectl get pods -o wide"
alias kd="kubectl get deployment -o wide"
alias ks="kubectl get svc -o wide"
alias kno="kubectl get nodes -o wide"

# Describe K8S resources 
alias kdp="kubectl describe pod"
alias kdd="kubectl describe deployment"
alias kds="kubectl describe service"

k config view --minify
```


# Deploy a sample application into your cluster in one new namespace.

As an example, you can any of the following examples:
- [https://github.com/dockersamples/example-voting-app]
- [https://github.com/GoogleCloudPlatform/microservices-demo]
- [https://github.com/microservices-demo/microservices-demo]

The vote web app is then available on port 31000 on each host of the cluster or port 5000 through a Load Balancer, the result web app is available on port 31001 or port 5001 through a Load Balancer.

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

vote_lb_ip=$(kubectl get svc -n ${NS_APP} -l app=vote -o jsonpath="{.items[*].status.loadBalancer.ingress[*].ip}")
result_lb_ip=$(kubectl get svc -n ${NS_APP} -l app=result -o jsonpath="{.items[*].status.loadBalancer.ingress[*].ip}")

curl http://$vote_lb_ip:5000
curl http://$result_lb_ip:5001

# https://learn.microsoft.com/en-us/azure/aks/use-node-public-ips

# az aks nodepool update -g rg-lzaks-spoke-aks-nodes --cluster-name aks-lzaks-cluster -n aks-poolappsamd-41974831-vmss --enable-node-public-ip

# az vmss list-instance-public-ips -g rg-lzaks-spoke-aks-nodes -n aks-poolappsamd-41974831-vmss 

# kubectl port-forward deployment/vote 8040:31000 -n ${NS_APP}
# kubectl port-forward deployment/result 8042:31001 -n ${NS_APP}

```


## Optional : install PROMETHEUS & GRAFANA

```sh
helm version
helm repo update

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade --install prom prometheus-community/kube-prometheus-stack -n monitoring --create-namespace `
       --set grafana.adminUser="grafana" --set grafana.adminPassword="@Aa123456789"
start powershell {kubectl port-forward service/prom-grafana 8000:80 -n monitoring}
start microsoft-edge:http://localhost:8000
# Access dashboard: http://localhost:8000
# login: grafana, password: @Aa123456789
```


# Install the Sysdig Agent

```sh
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
kubectl get ds -n sysdig-agent
kubectl get deploy -n sysdig-agent
kubectl get pods -n sysdig-agent

```


# Monitor

Verify the application status via Kubernetes Advisor, anything to highlight ?

Use PromQL Explorer to create some queries using metrics coming from or related with the Voting app (or the application you have chosen)

- One query needs to represent the cpu usage of each pod of the Voting app namespace (sysdig_container_cpu_cores_used)

```sh
# https://prometheus.io/docs/prometheus/latest/querying/basics/
sysdig_container_cpu_cores_used
sysdig_container_cpu_cores_used{kube_namespace_name="apps"}

# /!\ There is no request/limit in the Voting Apps, so the query will return NO DATA in the Apps namespace

sum(sysdig_container_cpu_cores_used{kube_namespace_name="sysdig-agent"}) by (kube_pod_name) 
/
sum(kube_pod_container_resource_requests{resource="cpu",kube_namespace_name="sysdig-agent"}) by (kube_pod_name)
```

- Other query needs to represent % the CPU Used (sysdig_container_cpu_cores_used) vs the CPU Requested
(kube_pod_container_resource_requests{resource=”cpu”}) for the Voting app pods

```sh


```


- If you can’t build these 2 queries, you can use other a similar query
  - Use the queries you have built to create a new dashboard
  - Use the queries you have built to create an alert related with the Voting
application

```sh
# Alert:
(sum(sysdig_container_cpu_cores_used{kube_namespace_name="sysdig-agent"}) by (kube_pod_name) 
/
sum(kube_pod_container_resource_requests{resource="cpu",kube_namespace_name="sysdig-agent"}) by (kube_pod_name)
) > 2


sum(sysdig_container_cpu_cores_used{kube_namespace_name="apps"}) by (kube_pod_name, container_name) 
/
sum(kube_pod_container_resource_requests{resource="cpu",kube_namespace_name="apps"}) by (kube_pod_name, container_name)

round(
  100 *
    sum(rate(sysdig_container_cpu_cores_used{kube_namespace_name="apps"}[42h])) by (pod_name, container_name) / 
    sum(kube_pod_container_resource_requests{resource="cpu",kube_namespace_name="apps"}) by (pod_name, container_name)
)

sum(sum by (kube_cluster_name)(kube_pod_container_resource_limits{resource="cpu",kube_cluster_name="aks-lzaks-cluster", kube_workload_type=~".*"}) )/sum(kube_node_status_capacity_cpu_cores{kube_cluster_name="aks-lzaks-cluster"})

sum by (kube_cluster_name, kube_namespace_name, kube_workload_type, kube_workload_name) (sysdig_container_cpu_cores_used{kube_namespace_name="apps"})


sum by (kube_cluster_name) (kube_pod_container_resource_requests{resource="cpu"}) / sum by (kube_cluster_name) (kube_node_status_allocatable_cpu_cores{kube_cluster_name="aks-lzaks-cluster"}) > ( (count by (kube_cluster_name) (kube_node_status_allocatable_cpu_cores{kube_cluster_name="aks-lzaks-cluster"})-1) / count by (kube_cluster_name) (kube_node_status_allocatable_cpu_cores{kube_cluster_name="aks-lzaks-cluster"}) )

sum by (kube_cluster_name,kube_node_name) (sysdig_container_cpu_cores_used{kube_cluster_name=~"aks-lzaks-cluster", kube_namespace_name="apps"}) / sum by (kube_cluster_name,kube_node_name) (kube_node_status_capacity_cpu_cores{kube_cluster_name="aks-lzaks-cluster"}) > 0.90
```

# Secure

## Review the vulnerabilities that are appearing in the Voting application

Define a Kubernetes CIS benchmark to your cluster
- What conclusions can you extract from the results?
- Enable some Runtime Policies and trigger some of them

==> Go to 'Posture' in the UI
See [https://docs.sysdig.com/en/docs/sysdig-secure/posture/compliance/](https://docs.sysdig.com/en/docs/sysdig-secure/posture/compliance/)

We recommend triggering “Terminal Shell in a Container” rule “Sysdig Runtime Notable Events” by accessing a container running in the cluster
- You can select other policies/rules to trigger

## Investigate Sysdig API via Swagger definition

The query should look something like:
https://<sysdig region API>/api/scanning/runtime/v2/workflows/results?cursor&filter=kubernetes.namespace.name%20%3D%20%22<namespace>%22&limit=100&order=desc&sort=runningVulnsBySev

Select one image from the Voting application (or the application you have deployed) and extract via API all vulnerabilities associated with that image
- Show us the API call(s) you have used to extract that information
- You can use curl, a script in bash/python, postman…

[https://eu1.app.sysdig.com/api/public/docs/index.html](https://eu1.app.sysdig.com/api/public/docs/index.html)
[https://eu1.app.sysdig.com/#/login](https://eu1.app.sysdig.com/#/login)


[Retrieve the Sysdig API Token](https://docs.sysdig.com/en/docs/administration/administration-settings/user-profile-and-password/retrieve-the-sysdig-api-token/#retrieve-the-sysdig-api-token)
When using the Sysdig API with custom scripts or applications, an API security token (specific to each team) must be supplied.
- Log in to Sysdig Monitor or Sysdig Secure and select Settings.
- Select User Profile. The Sysdig Monitor or Sysdig Secure API token is displayed (depending on which interface and team you logged in to).
- Copy the token for use, or click the Reset Token button to generate a new one. export SYSDIG_API_TOKEN="xxx"

```sh
set -euo pipefail
# access_token=$(az account get-access-token --query accessToken -o tsv)

kubectl create sa api-client -n ${NS_APP} 
# sa_secret_name=$(kubectl get sa api-client -n ${NS_APP} -o json | jq -Mr '.metadata.name')
export APPS_API_TOKEN=$(kubectl create token api-client -n ${NS_APP})


export SYSDIG_API_TOKEN="xxx"

curl -X GET -H "Authorization: Bearer $SYSDIG_API_TOKEN" https://eu1.app.sysdig.com/api/groupmappings


curl -X GET -H "Authorization: Bearer $SYSDIG_API_TOKEN" https://eu1.app.sysdig.com/api/scanning/runtime/v2/workflows/results?cursor&filter=kubernetes.namespace.name%20%3D%20%22apps%22&limit=100&order=desc&sort=runningVulnsBySev

curl -X GET https://eu1.app.sysdig.com/api/scanning/runtime/v2/workflows/results?cursor&filter=kubernetes.namespace.name%20%3D%20%22<namespace>%22&limit=100&order=desc&sort=runningVulnsBySev

```