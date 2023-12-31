module "vm_jumpbox_linux" {
  count  = var.enable_vm_jumpbox_linux ? 1 : 0
  source = "../modules/vm_linux"
  providers = {
    azurerm = azurerm
    # azurerm = azurerm.subscription_spoke
  }

  vm_name             = "vm-jumpbox-linux"
  resource_group_name = "rg-${var.prefix}-vm-linux"
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.subnet_vm.id
  tags                = var.tags
  subscription_id     = data.azurerm_subscription.subscription_spoke.id
  vm_size             = "Standard_B2s"
  admin_username      = "aksadm"
  admin_password      = var.aks_admin_password

}