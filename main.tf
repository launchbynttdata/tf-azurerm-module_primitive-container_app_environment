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

  dynamic "workload_profile" {
    for_each = var.workload_profiles

    content {
      name                  = each.value.name
      workload_profile_type = each.value.workload_profile_type
      maximum_count         = each.value.maximum_count
      minimum_count         = each.value.minimum_count
    }
  }

  mutual_tls_enabled = var.mutual_tls_enabled
  tags               = var.tags

}
