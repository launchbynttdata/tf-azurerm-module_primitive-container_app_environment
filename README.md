# tf-azurerm-module_primitive-container_app_environment

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

A Container App Environment. This is a building block for use with Container Apps and Container App Jobs.

## Local Development and Testing

To set yourself up for local development and testing activities, ensure you have the following software available on your PATH:

- make
- git (ensure your user.name and user.email are configured)
- [git-repo](https://gerrit.googlesource.com/git-repo#install)
- [`asdf`](https://asdf-vm.com) or [`mise`](https://mise.jdx.dev/)
- python3 (for pre-commit hooks)

You will also need to authenticate to the Cloud Provider. Terraform will use the default credential resolution mechanism, so ensure you are signed on through the CLI.

Clone this repository to your machine and issue the following command:

```
make configure
```

This will synchronize supporting repositories into this directory and expose additional targets.

To perform linting actions against the Terraform module and Terratests, issue the following command:

```
make lint
```

To provision cloud resources and perform tests against them, issue the following command:

```
make test
```

Note that `make test` causes the creation of some ignored files on your filesystem. This behavior is expected and we want to exclude any state or lockfiles from being pushed to the repository.

These two commands will be utilized in the pipeline and if you cannot run them successfully locally, you are unlikely to see a different result in the pipeline.

For convenience, a target exists that will execute both `make lint` and `make test` for you in sequence. Issue the following command to perform a holistic lint and test:

```
make check
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.117 |

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
| <a name="input_workload_profiles"></a> [workload\_profiles](#input\_workload\_profiles) | A list of workload profiles for the Container App Environment. Changing this forces a new resource to be created. | <pre>list(object({<br/>    name                  = string<br/>    workload_profile_type = string<br/>    maximum_count         = optional(number)<br/>    minimum_count         = optional(number)<br/>  }))</pre> | `[]` | no |
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
