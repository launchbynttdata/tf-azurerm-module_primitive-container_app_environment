// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

variable "name" {
  description = "The name of the Container App Environment. Changing this forces a new resource to be created."
  type        = string
  nullable    = false
}

variable "resource_group_name" {
  description = "The name of the Resource Group in which to create the Container App Environment. Changing this forces a new resource to be created."
  type        = string
  nullable    = false
}

variable "location" {
  description = "Specifies the supported Azure location where the Container App Environment is to exist. Changing this forces a new resource to be created."
  type        = string
  nullable    = false
}

variable "dapr_application_insights_connection_string" {
  description = "Application Insights connection string used by Dapr to export Service to Service communication telemetry. Changing this forces a new resource to be created."
  type        = string
  nullable    = true
  default     = null
}

variable "infrastructure_resource_group_name" {
  description = "Name of the platform-managed resource group created for the Managed Environment to host infrastructure resources. Changing this forces a new resource to be created."
  type        = string
  default     = null
  nullable    = true
}

variable "infrastructure_subnet_id" {
  description = "The existing Subnet to use for the Container Apps Control Plane. The subnet must have /21 or larger address space. Changing this forces a new resource to be created."
  type        = string
  default     = null
  nullable    = true
}

variable "internal_load_balancer_enabled" {
  description = "Should the Container Environment operate in Internal Load Balancing Mode? Defaults to false. Can only be enabled if `infrastructure_subnet_id` is specified. Changing this forces a new resource to be created."
  type        = bool
  default     = null
  nullable    = true
}

variable "zone_redundancy_enabled" {
  description = "Should the Container App Environment be created with Zone Redundancy enabled? Defaults to false. Can only be enabled if `infrastructure_subnet_id` is specified. Changing this forces a new resource to be created."
  type        = bool
  default     = null
  nullable    = true
}

variable "log_analytics_workspace_id" {
  description = "The ID for the Log Analytics Workspace to link this Container Apps Managed Environment to."
  type        = string
  default     = null
  nullable    = true
}

variable "workload_profiles" {
  description = "A list of workload profiles for the Container App Environment. `workload_profile_type` must be one of 'Consumption', 'D4', 'D8', 'D16', 'D32', 'E4', 'E8', 'E16', or 'E32'. If the type is 'Consumption', the name must also be 'Consumption'. Only one Consumption workload profile is allowed per environment. The default value (an empty list) will result in an environment that is Consumption-only. Changing this forces a new resource to be created."
  type = list(object({
    name                  = string
    workload_profile_type = string
    maximum_count         = optional(number)
    minimum_count         = optional(number)
  }))
  nullable = false
  default  = []

  validation {
    condition     = alltrue([for profile in var.workload_profiles : contains(["Consumption", "D4", "D8", "D16", "D32", "E4", "E8", "E16", "E32"], profile.workload_profile_type)])
    error_message = "Workload profile type must be one of 'Consumption', 'D4', 'D8', 'D16', 'D32', 'E4', 'E8', 'E16', or 'E32'."
  }

  validation {
    condition     = alltrue([for profile in var.workload_profiles : profile.workload_profile_type == "Consumption" ? profile.name == "Consumption" : true])
    error_message = "A Workload Profile with 'Consumption' as its type must also have the name 'Consumption'."
  }

  validation {
    condition     = length([for profile in var.workload_profiles : profile.workload_profile_type if profile.workload_profile_type == "Consumption"]) <= 1
    error_message = "Only one workload profile may be of 'Consumption' type."
  }
}

variable "mutual_tls_enabled" {
  description = "Should mutual transport layer security (mTLS) be enabled? Defaults to false."
  type        = bool
  default     = false
  nullable    = false
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  nullable    = true
  default     = {}
}
