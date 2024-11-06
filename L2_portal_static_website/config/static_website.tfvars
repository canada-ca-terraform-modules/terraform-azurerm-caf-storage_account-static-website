
static_websites = {
  website1 = {
    storage_account = {
      # Key defines the userDefinedString
      resource_group                = "portal_static_website" # Required: Resource group name, i.e Project, Management, DNS, etc, or the resource group ID
      account_tier                  = "Standard"              # Required: Possible values: Standard,Premium
      account_replication_type      = "GRS"                   # Required: Possible values: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS
      shared_access_key_enabled     = true                    # Optional: Possible values: true, false. Default: false. Can uncomment to set this value
      public_network_access_enabled = true
      static_website                = true # Optional: Set to true to enable static website with an empty index.html file. Default: false

        network_rules = {
          default_action = "Deny"             # Default: Deny
          ip_rules       = ["147.243.0.0/16"] # List of IP permitted to access the storage account
          #virtual_network_subnet_ids = ["MAZ", "OZ"]     # List of subnet permitted to access the storage account. Values can either be name, i.e MAZ, OZ, etc, or subnet ID
          #bypass                     = ["AzureServices"] # Default: AzureServices. List of Services/resources allowed to bypass firewall.
        }

      private_endpoint = {
        blob = {                        # Key defines the userDefinedstring
          resource_group    = "portal_static_website" # Required: Resource group name, i.e Project, Management, DNS, etc, or the resource group ID
          subnet            = "OZ"      # Required: Subnet name, i.e OZ,MAZ, etc, or the subnet ID
          subresource_names = ["blob"]  # Required: Subresource name determines to what service the private endpoint will connect to. see: https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource for list of subresrouce
          # local_dns_zone    = "privatelink.blob.core.windows.net" # Optional: Name of the local DNS zone for the private endpoint
        }
      }

    }

    front_door = {
      resource_group = "portal_static_website"
      location       = "global" # Front Door location should be set to "global"
      profile_sku    = "Standard_AzureFrontDoor"

      # Front Door Origin Groups
      origin_group = {
        session_affinity_enabled                                  = true
        restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 10
      }

      origin = {
        http_port                      = 80
        https_port                     = 443
        certificate_name_check_enabled = false
        enabled                        = true
        priority                       = 2
        weight                         = 50
        use_private_link = {
          enable          = false
          request_message = "Request access for Private Link Origin CDN Frontdoor"
          target_type     = "blob"
          location        = "canadacentral" # location of storage account
        #   private_link_target_id = "/subscriptions/a76af5cd-e42a-4ce1-af35-86a309543ed5/resourceGroups/G3Sc-CPMS_MMahdavian_portal_static_website-rg/providers/Microsoft.Storage/storageAccounts/example-storage-account" #id of storage acccount /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/example-rg/providers/Microsoft.Storage/storageAccounts/example-storage-account
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
          host_name           = "example"
          certificate_type    = "ManagedCertificate"
          minimum_tls_version = "TLS12"
        }
      }

      firewall_policy = {
        enabled                           = true
        mode                              = "Prevention"
        redirect_url                      = "https://www.microsoft.com"
        custom_block_response_status_code = 403
        custom_block_response_body        = "PGh0bWw+CjxoZWFkZXI+PHRpdGxlPkhlbGxvPC90aXRsZT48L2hlYWRlcj4KPGJvZHk+CkhlbGxvIHdvcmxkCjwvYm9keT4KPC9odG1sPg=="
      }

      # Front Door Security Policies
      security_policy = {
        patterns_to_match = ["/*"]
      }
    }

    aad_group = {
      owners  = ["user"]
      members = ["user"]
    }
  }
}
