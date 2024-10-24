resource "azurerm_api_management" "apim" {
  for_each = { for instance in var.apim_instances : instance.name => instance }

  name                          = each.value.name
  resource_group_name           = each.value.rg_name
  location                      = each.value.location
  tags                          = each.value.tags
  sku_name                      = each.value.sku_name
  publisher_name                = each.value.publisher_name
  publisher_email               = each.value.publisher_email
  client_certificate_enabled    = each.value.client_cetuficate_enabled
  gateway_disabled              = each.value.gateway_disabled
  min_api_version               = each.value.min_api_version
  public_ip_address_id          = each.value.public_ip_address_id
  public_network_access_enabled = each.value.public_network_access_enabled
  virtual_network_type          = each.value.virtual_network_type

  dynamic "additional_location" {
    for_each = each.value.additional_location != null ? each.value.additional_location : []
    content {
      location             = additional_location.value.location
      capacity             = additional_location.value.capacity
      zones                = additional_location.value.zones
      public_ip_address_id = additional_location.value.public_ip_address_id

      dynamic "virtual_network_configuration" {
        for_each = additional_location.value.virtual_network_configuration != null ? [additional_location.value.virtual_network_configuration] : []
        content {
          subnet_id = virtual_network_configuration.value.subnet_id
        }
      }
      gateway_disabled = additional_location.value.gateway_disabled
    }
  }

  dynamic "certificate" {
    for_each = each.value.certificate != null ? each.value.certificate : []
    content {
      encoded_certificate  = certificate.value.encoded_certificate
      store_name           = certificate.value.store_name
      certificate_password = certificate.value.certificate_password
    }
  }

  dynamic "hostname_configuration" {
    for_each = each.value.hostname_configuration != null ? [each.value.hostname_configuration] : []
    content {
      dynamic "management" {
        for_each = try(each.value.hostname_configuration.management, [])
        content {
          host_name                       = management.value.host_name
          key_vault_id                    = management.value.key_vault_id
          certificate                     = management.value.certificate
          certificate_password            = management.value.certificate_password
          negotiate_client_certificate    = management.value.negotiate_client_certificate
          ssl_keyvault_identity_client_id = management.value.ssl_keyvault_identity_client_id
        }
      }

      dynamic "portal" {
        for_each = try(each.value.hostname_configuration.portal, [])
        content {
          host_name                       = portal.value.host_name
          key_vault_id                    = portal.value.key_vault_id
          certificate                     = portal.value.certificate
          certificate_password            = portal.value.certificate_password
          negotiate_client_certificate    = portal.value.negotiate_client_certificate
          ssl_keyvault_identity_client_id = portal.value.ssl_keyvault_identity_client_id
        }
      }

      dynamic "developer_portal" {
        for_each = try(each.value.hostname_configuration.developer_portal, [])
        content {
          host_name                       = developer_portal.value.host_name
          key_vault_id                    = developer_portal.value.key_vault_id
          certificate                     = developer_portal.value.certificate
          certificate_password            = developer_portal.value.certificate_password
          negotiate_client_certificate    = developer_portal.value.negotiate_client_certificate
          ssl_keyvault_identity_client_id = developer_portal.value.ssl_keyvault_identity_client_id
        }
      }

      dynamic "proxy" {
        for_each = try(each.value.hostname_configuration.proxy, [])
        content {
          default_ssl_binding             = proxy.value.default_ssl_binding
          host_name                       = proxy.value.host_name
          key_vault_id                    = proxy.value.key_vault_id
          certificate                     = proxy.value.certificate
          certificate_password            = proxy.value.certificate_password
          negotiate_client_certificate    = proxy.value.negotiate_client_certificate
          ssl_keyvault_identity_client_id = proxy.value.ssl_keyvault_identity_client_id
        }
      }

      dynamic "scm" {
        for_each = try(each.value.hostname_configuration.scm, [])
        content {
          host_name                       = scm.value.host_name
          key_vault_id                    = scm.value.key_vault_id
          certificate                     = scm.value.certificate
          certificate_password            = scm.value.certificate_password
          negotiate_client_certificate    = scm.value.negotiate_client_certificate
          ssl_keyvault_identity_client_id = scm.value.ssl_keyvault_identity_client_id
        }
      }
    }
  }

  dynamic "delegation" {
    for_each = each.value.delegation != null ? [each.value.delegation] : []
    content {
      subscriptions_enabled     = delegation.value.subscriptions_enabled
      user_registration_enabled = delegation.value.user_registration_enabled
      url                       = delegation.value.url
      validation_key            = delegation.value.validation_key
    }
  }

  dynamic "sign_in" {
    for_each = each.value.sign_in != null ? [each.value.sign_in] : []
    content {
      enabled = sign_in.value.enabled
    }
  }

  dynamic "sign_up" {
    for_each = each.value.sign_up != null ? [each.value.sign_up] : []
    content {
      enabled = sign_up.value.enabled

      dynamic "terms_of_service" {
        for_each = sign_up.value.terms_of_service != null ? [sign_up.value.terms_of_service] : []
        content {
          enabled          = terms_of_service.value.enabled
          consent_required = terms_of_service.value.consent_required
          text             = terms_of_service.value.text
        }
      }
    }
  }

  dynamic "security" {
    for_each = each.value.security != null ? [each.value.security] : []
    content {
      enable_backend_ssl30                                = security.value.enable_backend_ssl30
      enable_backend_tls10                                = security.value.enable_backend_tls10
      enable_backend_tls11                                = security.value.enable_backend_tls11
      enable_frontend_ssl30                               = security.value.enable_frontend_ssl30
      enable_frontend_tls10                               = security.value.enable_frontend_tls10
      enable_frontend_tls11                               = security.value.enable_frontend_tls11
      tls_ecdhe_ecdsa_with_aes128_cbc_sha_ciphers_enabled = security.value.tls_ecdhe_ecdsa_with_aes128_cbc_sha_ciphers_enabled
      tls_ecdhe_ecdsa_with_aes256_cbc_sha_ciphers_enabled = security.value.tls_ecdhe_ecdsa_with_aes256_cbc_sha_ciphers_enabled
      tls_ecdhe_rsa_with_aes128_cbc_sha_ciphers_enabled   = security.value.tls_ecdhe_rsa_with_aes128_cbc_sha_ciphers_enabled
      tls_ecdhe_rsa_with_aes256_cbc_sha_ciphers_enabled   = security.value.tls_ecdhe_rsa_with_aes256_cbc_sha_ciphers_enabled
      tls_rsa_with_aes128_cbc_sha256_ciphers_enabled      = security.value.tls_rsa_with_aes128_cbc_sha256_ciphers_enabled
      tls_rsa_with_aes128_cbc_sha_ciphers_enabled         = security.value.tls_rsa_with_aes128_cbc_sha_ciphers_enabled
      tls_rsa_with_aes128_gcm_sha256_ciphers_enabled      = security.value.tls_rsa_with_aes128_gcm_sha256_ciphers_enabled
      tls_rsa_with_aes256_gcm_sha384_ciphers_enabled      = security.value.tls_rsa_with_aes256_gcm_sha384_ciphers_enabled
      tls_rsa_with_aes256_cbc_sha256_ciphers_enabled      = security.value.tls_rsa_with_aes256_cbc_sha256_ciphers_enabled
      tls_rsa_with_aes256_cbc_sha_ciphers_enabled         = security.value.tls_rsa_with_aes256_cbc_sha_ciphers_enabled
      triple_des_ciphers_enabled                          = security.value.triple_des_ciphers_enabled
    }
  }
  dynamic "identity" {
    for_each = each.value.identity_type == "SystemAssigned" ? [each.value.identity_type] : []
    content {
      type = each.value.identity_type
    }
  }

  dynamic "identity" {
    for_each = each.value.identity_type == "SystemAssigned, UserAssigned" ? [each.value.identity_type] : []
    content {
      type         = each.value.identity_type
      identity_ids = try(each.value.identity_ids, [])
    }
  }


  dynamic "identity" {
    for_each = each.value.identity_type == "UserAssigned" ? [each.value.identity_type] : []
    content {
      type         = each.value.identity_type
      identity_ids = length(try(each.value.identity_ids, [])) > 0 ? each.value.identity_ids : []
    }
  }
}
