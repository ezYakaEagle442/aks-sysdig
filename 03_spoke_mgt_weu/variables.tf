variable "prefix" {
  type        = string
  description = "A prefix used for all resources in this example"
}

variable "aks_admin_password" {
  type        = string
}

variable "resources_location" {
  description = "Location of the resource group."
}

variable "cidr_vnet_spoke_mgt" {
  description = "CIDR for Management/Jumpbox VM VNET."
}

variable "cidr_subnet_mgt" {
  description = "CIDR for Management/Jumpbox VM Subnet."
}

variable "enable_vnet_peering" {
  type        = bool
  description = "Enable VNET peering between AKS VNET and Jumpbox VNET"
}

variable "enable_firewall" {
  type        = bool
  description = "Creates an Azure Firewall."
}

variable "enable_vm_jumpbox_windows" {
  description = "Creates Azure Windows VM."
  default     = "true"
}

variable "enable_vm_jumpbox_linux" {
  description = "Creates Azure Linux VM."
  default     = "true"
}

variable "subscription_id_hub" {
  description = "Subscription ID for Hub"
}

variable "subscription_id_spoke" {
  description = "Subscription ID for Spoke"
}

variable "tenant_id_hub" {
  description = "Azure AD tenant ID for Hub"
}

variable "tenant_id_spoke" {
  description = "Azure AD tenant ID for Spoke"
}

variable "tags" {
  type = map(string)

  default = {
    source = "terraform"
    environment : "development"
    architecture : "Hub&Spoke"
  }
}
