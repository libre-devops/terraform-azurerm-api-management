resource "azurerm_api_management" "apim" {
  location            = var.location
  name                = var.apim_name
  publisher_email     = var.publisher_email
  publisher_name      = var.publisher_name
  resource_group_name = var.rg_name
  sku_name            = try(var.sku, "Consumption_0")
  client_certificate_enabled = try(var.client_certificate_enabled, null)
  gateway_disabled = lookup(var.apim_settings, "additional_location", {}) != {} ? var.gateway_disabled : null
  min_api_version = try(var.min_api_version, null)
  zones = tolist(var.zones)
  notification_sender_email = try(var.notification_sender_email, null)
  public_network_access_enabled = try(var.public_network_access_enabled, true)
  virtual_network_type = try(var.virtual_network_type, "Internal", "None")
  tags                 = var.tags


  dynamic "additional_location" {
    for_each = lookup(var.apim_settings, "additional_location", {}) != {} ? [1] : []
    content {
    location   = lookup(var.apim_settings.additional_location, "location", var.location)
    capacity =  lookup(var.apim_settings.additional_location, "capacity", null)
    zones    = tolist(lookup(var.apim_settings.additional_location, "zones", null))
    public_ip_address_id = lookup(var.apim_settings.additional_location, "public_ip_address_id", null)
    }
  }

  dynamic "certificate" {
    for_each = lookup(var.apim_settings, "certificate", {}) != {} ? [1] : []
    content {
      encoded_certificate = lookup(var.apim_settings.certificate, "encoded_certificate", null)
      store_name = lookup(var.apim_settings.certificate, "store_name", null)
      certificate_password = lookup(var.apim_settings.certificate, "certificate_password", null)
    }
  }

  dynamic "delegation" {
    for_each = lookup(var.apim_settings, "delegation", {}) != {} ? [1] : []
    content {
      subscriptions_enabled = lookup(var.apim_settings.delegation, "subscriptions_enabled", null)
      user_registration_enabled = lookup(var.apim_settings.delegation, "user_registration_enabled", null)
      url = lookup(var.apim_settings.delegation, "url", null)
      validation_key = lookup(var.apim_settings.delegation, "validation_key", null)
    }
  }

  dynamic "hostname_configuration" {
    for_each = lookup(var.apim_settings, "hostname_configuration", {}) != {} ? [1] : []
    content {
      dynamic "management" {
        for_each = lookup(var.apim_settings.hostname_configuration, "management", {}) != {} ? [1] : []
        content {
        host_name = lookup(var.apim_settings.hostname_configuration.management, "host_name", null)
        key_vault_id = lookup(var.apim_settings.hostname_configuration.management, "key_vault_id", null)
          certificate = lookup(var.apim_settings.hostname_configuration.management, "certificate", null)
          certificate_password = lookup(var.apim_settings.hostname_configuration.management, "certificate_password", null)
          negotiate_client_certificate = lookup(var.apim_settings.hostname_configuration.management, "negotiate_client_certificate", null)
          ssl_keyvault_identity_client_id = lookup(var.apim_settings.hostname_configuration.management, "ssl_keyvault_identity_client_id", null)
        }
      }
    }
  }
management - (Optional) One or more management blocks as documented below.

portal - (Optional) One or more portal blocks as documented below.

developer_portal - (Optional) One or more developer_portal blocks as documented below.

proxy - (Optional) One or more proxy blocks as documented below.

scm - (Optional) One or more scm blocks as documented below


  dynamic "identity" {
    for_each = length(var.identity_ids) == 0 && var.identity_type == "SystemAssigned" ? [var.identity_type] : []
    content {
      type = var.identity_type
    }
  }

  dynamic "identity" {
    for_each = length(var.identity_ids) == 0 && var.identity_type == "SystemAssigned, UserAssigned" ? [var.identity_type] : []
    content {
      type = var.identity_type
      identity_ids = length(var.identity_ids) > 0 ? var.identity_ids : []
    }
  }

  dynamic "identity" {
    for_each = length(var.identity_ids) > 0 || var.identity_type == "UserAssigned" ? [var.identity_type] : []
    content {
      type         = var.identity_type
      identity_ids = length(var.identity_ids) > 0 ? var.identity_ids : []
    }
  }
}