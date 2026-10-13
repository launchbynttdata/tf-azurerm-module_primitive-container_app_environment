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

locals {
  user_assigned_identity_ids = toset(
    var.identity == null ? [] : coalesce(var.identity.identity_ids, [])
  )

  system_assigned_principal_id = try(one(azurerm_container_app_environment.environment.identity).principal_id, null)
  system_assigned_tenant_id    = try(one(azurerm_container_app_environment.environment.identity).tenant_id, null)
}

data "azurerm_user_assigned_identity" "assigned" {
  for_each = local.user_assigned_identity_ids

  name = regex(
    "(?i)^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft\\.ManagedIdentity/userAssignedIdentities/([^/]+)$",
    each.value,
  )[0]
  resource_group_name = regex(
    "(?i)^/subscriptions/[^/]+/resourceGroups/([^/]+)/providers/Microsoft\\.ManagedIdentity/userAssignedIdentities/[^/]+$",
    each.value,
  )[0]
}

resource "azurerm_container_app_environment" "environment" {
  name                                        = var.name
  resource_group_name                         = var.resource_group_name
  location                                    = var.location
  dapr_application_insights_connection_string = var.dapr_application_insights_connection_string
  infrastructure_resource_group_name          = var.infrastructure_resource_group_name
  infrastructure_subnet_id                    = var.infrastructure_subnet_id
  internal_load_balancer_enabled              = var.internal_load_balancer_enabled
  zone_redundancy_enabled                     = var.zone_redundancy_enabled
  log_analytics_workspace_id                  = var.log_analytics_workspace_id

  dynamic "identity" {
    for_each = var.identity == null ? [] : [var.identity]

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "workload_profile" {
    for_each = var.workload_profiles

    content {
      name                  = workload_profile.value.name
      workload_profile_type = workload_profile.value.workload_profile_type
      maximum_count         = workload_profile.value.maximum_count
      minimum_count         = workload_profile.value.minimum_count
    }
  }

  mutual_tls_enabled = var.mutual_tls_enabled
  tags               = var.tags

}
