# tf-azurerm-module_primitive-container_app_environment

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

A Container App Environment. This is a building block for use with Container Apps and Container App Jobs.

## Usage

See [examples/minimal](examples/minimal) for a deployable example.

## Module Development

### Pre-Requisites

The following commands should be available on your system:

- `asdf` or `mise`
- `make`
- `python3` (for pre-commit)

Additionally, your `git` user and email must be configured. Run `make configure` from the repository root to confirm that these requirements are met.

### Pre-Commit hooks

The [.pre-commit-config.yaml](.pre-commit-config.yaml) file defines hooks for Terraform formatting, validation, documentation generation, and secret detection. Hooks are installed by `make configure`. Go linting runs through `make lint` locally and in CI.

### Terratest examples

Tests in `tests/post_deploy_functional/` and `tests/post_deploy_functional_readonly/` explicitly target `examples/minimal`. The functional suite applies and destroys the example; the readonly suite uses the non-destructive runner against existing infrastructure.

### Local Validation

Before pushing changes:

1. Run `make configure` successfully.
2. Sign in to Azure and select the appropriate subscription.
3. Run the linters:

```shell
make lint
```

4. When Azure credentials are available, run the integration tests (apply, test, and destroy):

```shell
make test
```

Pre-commit validation, linting, and tests also run in CI.

### Review & Merge Process

Open a pull request to `main`. The PR title must follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/#specification) format to merge and drive semantic versioning. Ensure CI passes, address review feedback, and obtain the approvals required by `CODEOWNERS`.

### Automatic Updates

Shared configuration and workflows are managed through [launch-terraform-skeleton](https://github.com/launchbynttdata/launch-terraform-skeleton). Avoid one-off edits to generated skeleton files unless necessary. Use `copier check-update` and `copier update` when refreshing from the skeleton.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.68 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_container_app_environment.environment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_environment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the Container App Environment. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the Resource Group in which to create the Container App Environment. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Specifies the supported Azure location where the Container App Environment is to exist. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_dapr_application_insights_connection_string"></a> [dapr\_application\_insights\_connection\_string](#input\_dapr\_application\_insights\_connection\_string) | Application Insights connection string used by Dapr to export Service to Service communication telemetry. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_infrastructure_resource_group_name"></a> [infrastructure\_resource\_group\_name](#input\_infrastructure\_resource\_group\_name) | Name of the platform-managed resource group created for the Managed Environment to host infrastructure resources. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_infrastructure_subnet_id"></a> [infrastructure\_subnet\_id](#input\_infrastructure\_subnet\_id) | The existing Subnet to use for the Container Apps Control Plane. The subnet must have /21 or larger address space. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_internal_load_balancer_enabled"></a> [internal\_load\_balancer\_enabled](#input\_internal\_load\_balancer\_enabled) | Should the Container Environment operate in Internal Load Balancing Mode? Defaults to false. Can only be enabled if `infrastructure_subnet_id` is specified. Changing this forces a new resource to be created. | `bool` | `null` | no |
| <a name="input_zone_redundancy_enabled"></a> [zone\_redundancy\_enabled](#input\_zone\_redundancy\_enabled) | Should the Container App Environment be created with Zone Redundancy enabled? Defaults to false. Can only be enabled if `infrastructure_subnet_id` is specified. Changing this forces a new resource to be created. | `bool` | `null` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | The ID for the Log Analytics Workspace to link this Container Apps Managed Environment to. | `string` | `null` | no |
| <a name="input_workload_profiles"></a> [workload\_profiles](#input\_workload\_profiles) | A list of workload profiles for the Container App Environment. `workload_profile_type` must be one of 'Consumption', 'D4', 'D8', 'D16', 'D32', 'E4', 'E8', 'E16', or 'E32'. If the type is 'Consumption', the name must also be 'Consumption'. Only one Consumption workload profile is allowed per environment. The default value (an empty list) will result in an environment that is Consumption-only. Changing this forces a new resource to be created. | <pre>list(object({<br/>    name                  = string<br/>    workload_profile_type = string<br/>    maximum_count         = optional(number)<br/>    minimum_count         = optional(number)<br/>  }))</pre> | `[]` | no |
| <a name="input_mutual_tls_enabled"></a> [mutual\_tls\_enabled](#input\_mutual\_tls\_enabled) | Should mutual transport layer security (mTLS) be enabled? Defaults to false. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Container App Environment. |
| <a name="output_name"></a> [name](#output\_name) | Name of the Container App Environment. |
| <a name="output_custom_domain_verification_id"></a> [custom\_domain\_verification\_id](#output\_custom\_domain\_verification\_id) | The ID of the Custom Domain Verification for this Container App Environment. |
| <a name="output_default_domain"></a> [default\_domain](#output\_default\_domain) | The default, publicly resolvable, name of this Container App Environment. |
| <a name="output_docker_bridge_cidr"></a> [docker\_bridge\_cidr](#output\_docker\_bridge\_cidr) | The network addressing in which the Container Apps in this Container App Environment will reside in CIDR notation. This property only has a value when infrastructure\_subnet\_id is configured and will be a range within the CIDR of the Subnet. |
| <a name="output_platform_reserved_cidr"></a> [platform\_reserved\_cidr](#output\_platform\_reserved\_cidr) | The IP range, in CIDR notation, that is reserved for environment infrastructure IP addresses. This property only has a value when infrastructure\_subnet\_id is configured and will be a range within the CIDR of the Subnet. |
| <a name="output_platform_reserved_dns_ip_address"></a> [platform\_reserved\_dns\_ip\_address](#output\_platform\_reserved\_dns\_ip\_address) | The IP address from the IP range defined by platform\_reserved\_cidr that is reserved for the internal DNS server. This property only has a value when infrastructure\_subnet\_id is configured and will be a value within the CIDR of the Subnet. |
| <a name="output_static_ip_address"></a> [static\_ip\_address](#output\_static\_ip\_address) | The static IP address assigned to the Container App Environment. This will be a Public IP unless internal\_load\_balancer\_enabled is set to true, in which case an IP in the Internal Subnet will be reserved. |
<!-- END_TF_DOCS -->
