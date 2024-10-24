module "rg" {
  source = "libre-devops/rg/azurerm"

  rg_name  = "rg-${var.short}-${var.loc}-${var.env}-01"
  location = local.location
  tags     = local.tags
}

module "apim" {
  source = "../../"

  apim_instances = [
    {
      rg_name  = module.rg.rg_name
      location = module.rg.rg_location
      tags     = module.rg.rg_tags

      name             = "apim-${var.short}-${var.loc}-${var.env}-01"
      publisher_name   = "Libre DevOps"
      publisher_email  = "hello@libredevops.org"
      sku_name         = "Consumption_0" # Consumption SKU
      gateway_disabled = false
      identity_type    = "SystemAssigned"
      identity_ids     = []
    }
  ]
}