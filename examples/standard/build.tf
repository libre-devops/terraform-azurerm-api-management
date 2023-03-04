module "rg" {
  source = "registry.terraform.io/libre-devops/rg/azurerm"

  rg_name  = "rg-${var.short}-${var.loc}-${terraform.workspace}-build" // rg-ldo-euw-dev-build
  location = local.location                                            // compares var.loc with the var.regions var to match a long-hand name, in this case, "euw", so "westeurope"
  tags     = local.tags

  #  lock_level = "CanNotDelete" // Do not set this value to skip lock
}

module "apim" {
  source = "registry.terraform.io/libre-devops/api-management/azurerm"

  rg_name         = module.rg.rg_name
  location        = module.rg.rg_location
  tags            = module.rg.rg_tags
  apim_name       = "apim-${var.short}-${var.loc}-${terraform.workspace}-01"
  publisher_email = "craig@craigthacker.dev"
  publisher_name  = "Craig Thacker"
  identity_type   = "SystemAssigned, UserAssigned"
  identity_ids    = [data.azurerm_user_assigned_identity.mgmt_user_assigned_id.id]
}