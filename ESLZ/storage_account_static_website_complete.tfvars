static_websites = {
  website1 = {
    storage_account = {
      # Key defines the userDefinedString
      resource_group           = "Project"  # Required: Resource group name, i.e Project, Management, DNS, etc, or the resource group ID
      account_tier             = "Standard" # Required: Possible values: Standard,Premium
      account_replication_type = "GRS"      # Required: Possible values: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS

      account_kind                    = "StorageV2" # Optional: possible values: BlobStorage, BlockBlobStorage, FileStorage, Storage, StorageV2. Default: StorageV2
      access_tier                     = "Hot"       # Optional: Possible values: Hot, Cool. Default: Hot
      public_network_access_enabled   = true        # Optional: Possible values: true, false. Default: false
      allow_nested_items_to_be_public = false       # Optional: Possible values: true, false. Default: false. Can uncomment to set this value
      # https_traffic_only_enabled        = true        # Optional: Possible values: true, false. Default: true. Can uncomment to set this value
      # min_tls_version                  = "TLS1_2"    # Optional: Possible values: TLS1_0, TLS1_1, TLS1_2. Default: TLS1_2. Can uncomment to set this value
      shared_access_key_enabled = true # Optional: Possible values: true, false. Default: false. Can uncomment to set this value
      # default_to_oauth_authentication  = false       # Optional: Possible values: true, false. Default: false. Can uncomment to set this value
      # is_hns_enabled                   = false       # Optional: Possible values: true, false. Default: false. Can uncomment to set this value
      # nfsv3_enabled                    = false       # Optional: Possible values: true, false. Default: false. Can uncomment to set this value
      # cross_tenant_replication_enabled = true        # Optional: Possible values: true, false. Default: true. Can uncomment to set this value

      static_website = true # Optional: Set to true to enable static website with an empty index.html file. Default: false

      # Optional: Set network rules for the storage account. public_network_access_enabled needs to be set to true for this block to properly work
      # Can uncomment to deploy it
      network_rules = {
        default_action = "Deny"             # Default: Deny
        ip_rules       = ["147.243.0.0/16"] # List of IP permitted to access the storage account
        #virtual_network_subnet_ids = ["MAZ", "OZ"]     # List of subnet permitted to access the storage account. Values can either be name, i.e MAZ, OZ, etc, or subnet ID
        bypass                     = ["AzureServices"] # Default: AzureServices. List of Services/resources allowed to bypass firewall.
      }

      # Sets SAS policies, only valid if the shared_access_key_enabled is set to true
      #sas_policy = {
      #   expiration_period = "90.00:00:00"              # Required: Format for the period is DD.HH:MM:SS
      #   expiration_action = "Log"                      # Optional: Only possible value is Log
      # }

      # Optional: Defines a private endpoint for the storage account
      # Can be commented out if no private endpoint is required
      # private_endpoint = {
      #   blob = {                                                  # Key defines the userDefinedstring
      #     resource_group    = "Project"                           # Required: Resource group name, i.e Project, Management, DNS, etc, or the resource group ID
      #     subnet            = "OZ"                                # Required: Subnet name, i.e OZ,MAZ, etc, or the subnet ID
      #     subresource_names = ["blob"]                            # Required: Subresource name determines to what service the private endpoint will connect to. see: https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource for list of subresrouce
      #     # local_dns_zone    = "privatelink.blob.core.windows.net" # Optional: Name of the local DNS zone for the private endpoint
      #   }
      # }

    }

    front_door = {
      # Resource Group and Location
      resource_group = "Project"
      location       = "global" # Front Door location should be set to "global"

      # Front Door Profile Configuration
      profile_name = "example-frontdoor-profile"
      profile_sku  = "Premium_AzureFrontDoor" # Options: Standard_AzureFrontDoor, Premium_AzureFrontDoor
      local_dns = {
        add_local_dns_record  = true
        local_dns_zone_name   = "zone1"
        local_dns_record_name = "www"
        certificate_type      = "ManagedCertificate"
        minimum_tls_version   = "TLS12"
        ttl                   = 3600
      }

      # Front Door Origin Groups
      origin_group = {
        session_affinity_enabled                                  = true
        restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 10
        health_probe_interval_in_seconds                          = 240
        health_probe_path                                         = "/healthProbe"
        health_probe_protocol                                     = "Https"
        health_probe_request_type                                 = "HEAD"
        load_balancing_additional_latency_in_milliseconds         = 0
        load_balancing_sample_size                                = 16
        load_balancing_successful_samples_required                = 3
      }

      # Front Door Origins
      origin = {
        http_port                      = 80
        https_port                     = 443
        certificate_name_check_enabled = false
        enabled                        = true
        priority                       = 2
        weight                         = 50
        use_private_link = {
          enable                 = false
          request_message        = "Request access for Private Link Origin CDN Frontdoor"
          target_type            = "blob"
          location               = "canadacentral" # location of storage account
          private_link_target_id = ""              #id of storage acccount /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/example-rg/providers/Microsoft.Storage/storageAccounts/example-storage-account
        }
        use_private_link_service = {
          enable                 = false
          request_message        = "Request access for Private Link Origin CDN Frontdoor"
          location               = "canadacentral" # location of resource group
          private_link_target_id = ""              #id of private link service
        }
      }

      # Front Door Custom Domains
      custom_domains = {
        custom-domain1 = {
          host_name           = "custom.example.com"
          certificate_type    = "ManagedCertificate"
          minimum_tls_version = "TLS12"
        }
      }

      # Front Door Routes
      route = {
        supported_protocols    = ["Https", "Http"]
        patterns_to_match      = ["/*"]
        forwarding_protocol    = "MatchRequest"
        enabled                = true
        link_to_default_domain = true
        https_redirect_enabled = true
        cache = {
          enabled                       = false
          query_string_caching_behavior = "IgnoreQueryString"
          query_strings                 = []
          compression_enabled           = false
          content_types_to_compress     = ["text/html"]
        }
      }


      # Front Door Rule Sets
    #   rules = {
    #     rule1 = {
    #       order = 1
    #       conditions = [
    #         {
    #           type         = "request_uri_condition"
    #           operator     = "Equal"
    #           negate       = false
    #           match_values = ["/example-path"]
    #           selector     = ""
    #           transforms   = ["Lowercase"]
    #         }
    #       ]
    #       actions = [
    #         {
    #           action_type         = "route_configuration_override_action"
    #           forwarding_protocol = "HttpsOnly"
    #           #cache_duration = "364.23:59:59" #cache_duration' field must not be set if the 'cache_behavior' is 'HonorOrigin'
    #           cache_behavior                = "HonorOrigin"       #cache_behavior to be one of ["HonorOrigin" "OverrideAlways" "OverrideIfOriginMissing" "Disabled"]
    #           query_string_caching_behavior = "IgnoreQueryString" # be one of ["IgnoreQueryString" "UseQueryString" "IgnoreSpecifiedQueryStrings" "IncludeSpecifiedQueryStrings"]
    #         }
    #       ]
    #     }

    #     rule2 = {
    #       order = 2
    #       conditions = [
    #         {
    #           type             = "request_header_condition"
    #           header_name      = "User-Agent"
    #           operator         = "Equal"
    #           negate_condition = false
    #           match_values     = ["Chrome"]
    #           transforms       = []
    #         }
    #       ]
    #       actions = [
    #         {
    #           action_type              = "request_header_action"
    #           header_action            = "Overwrite"
    #           header_name              = "X-Custom-Header"
    #           header_value             = "CustomValue"
    #           cache_behavior           = ""
    #           cache_duration           = ""
    #           redirect_type            = ""
    #           destination_protocol     = ""
    #           destination_host         = ""
    #           destination_path         = ""
    #           destination_query_string = ""
    #           preserve_unmatched_path  = false
    #         }
    #       ]
    #     }
    #   }

      firewall_policy = {
        enabled                           = true
        mode                              = "Prevention"
        redirect_url                      = "https://www.microsoft.com"
        custom_block_response_status_code = 403
        custom_block_response_body        = "PGh0bWw+CjxoZWFkZXI+PHRpdGxlPkhlbGxvPC90aXRsZT48L2hlYWRlcj4KPGJvZHk+CkhlbGxvIHdvcmxkCjwvYm9keT4KPC9odG1sPg=="
        # custom_rules ={
        #     rule1 ={
        #         enabled                        = true
        #         priority                       = 1
        #         rate_limit_duration_in_minutes = 1
        #         rate_limit_threshold           = 10
        #         type                           = "MatchRule"
        #         action                         = "Block"
        #         match_variable     = "RemoteAddr"
        #         operator           = "IPMatch"
        #         negation_condition = false
        #         match_values       = ["10.0.1.0/24", "10.0.0.0/24"]
        #     }

        #     rule2={
        #         enabled                        = true
        #         priority                       = 2
        #         rate_limit_duration_in_minutes = 1
        #         rate_limit_threshold           = 10
        #         type                           = "MatchRule"
        #         action                         = "Block"
        #         match_variable     = "RemoteAddr"
        #         operator           = "IPMatch"
        #         negation_condition = false
        #         match_values       = ["192.168.1.0/24"]
        #     }
        # }
        # managed_rules ={
        #     rule1 = {
        #         type    = "Microsoft_BotManagerRuleSet"
        #         version = "1.0"
        #         action  = "Log"
        #     }
        #     rule2  = {
        #         type    = "DefaultRuleSet"
        #         version = "1.0"
        #         action = "Allow"
        #         exclusions = {
        #             exclusion1 = {
        #                 match_variable = "QueryStringArgNames"
        #                 operator       = "Equals"
        #                 selector       = "not_suspicious"
        #             }
        #         }
        #         overrides = {
        #             override1 = {
        #                 rule_group_name = "PHP"
        #                 rules = {
        #                     rule_1 = {
        #                         rule_id = "933100"
        #                         enabled = false
        #                         action  = "Block"
        #                     }
        #                 }

        #             }
        #             override2 = {
        #                 rule_group_name = "SQLI"
        #                 exclusions = {
        #                     exclusion ={
        #                         match_variable = "QueryStringArgNames"
        #                         operator       = "Equals"
        #                         selector       = "really_not_suspicious"
        #                     }
        #                 }

        #                 rules = {
        #                     rule_2 ={
        #                         rule_id = "942200"
        #                         action  = "Block"
        #                         exclusion ={
        #                         match_variable = "QueryStringArgNames"
        #                         operator       = "Equals"
        #                         selector       = "innocent"
        #                         }
        #                     }
        #                 }

        #             }
        #         }
        #     }
        # }

      }
      # Front Door Security Policies
      security_policy = {
        patterns_to_match = ["/*"]
      }

      # Front Door Secret
      # secret = {
      #     key_vault_certificate_id = "" # required. kevault certificate id
      # }
    }
  }
}
