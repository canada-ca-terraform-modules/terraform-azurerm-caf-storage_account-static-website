# terraform-azurerm-caf-storage_account-static-website
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_front_door"></a> [front\_door](#module\_front\_door) | github.com/canada-ca-terraform-modules/terraform-azurerm-caf-front-door.git | v1.0.0 |
| <a name="module_storage-account"></a> [storage-account](#module\_storage-account) | github.com/canada-ca-terraform-modules/terraform-azurerm-caf-storage_accountV2.git | v1.0.4 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | (Required) 4 character string defining the environment name prefix for the VM | `string` | `"dev"` | no |
| <a name="input_group"></a> [group](#input\_group) | (Required) Character string defining the group for the target subscription | `string` | `"test"` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure location for the VM | `string` | `"canadacentral"` | no |
| <a name="input_project"></a> [project](#input\_project) | (Required) Character string defining the project for the target subscription | `string` | `"test"` | no |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Required) Resource group object for the front door | `any` | `{}` | no |
| <a name="input_static_websites"></a> [static\_websites](#input\_static\_websites) | value | `any` | `{}` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnets objects | `any` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags that will be applied to every associated VM resource | `map(string)` | `{}` | no |
| <a name="input_userDefinedString"></a> [userDefinedString](#input\_userDefinedString) | (Required) User defined portion value for the name of the VM. | `string` | `"test"` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | (Required) Resource DNS zone object for the front door | `any` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->