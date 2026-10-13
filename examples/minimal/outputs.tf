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

output "resource_group_id" {
  description = "The ID of the example resource group."
  value       = module.resource_group.id
}

output "resource_group_name" {
  description = "The name of the example resource group."
  value       = module.resource_group.name
}

output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace used by the Container App Environment."
  value       = module.log_analytics_workspace.id
}

output "log_analytics_workspace_name" {
  description = "The name of the Log Analytics workspace used by the Container App Environment."
  value       = module.log_analytics_workspace.name
}

output "container_app_environment_id" {
  description = "The ID of the Container App Environment."
  value       = module.container_app_environment.id
}

output "container_app_environment_name" {
  description = "The name of the Container App Environment."
  value       = module.container_app_environment.name
}

output "infrastructure_resource_group_name" {
  description = "Name of the platform-managed resource group Azure creates for this environment."
  value       = module.resource_names["infra_rg"][var.resource_names_strategy]
}

output "identity_principal_id" {
  description = "Principal ID of the system-assigned identity on the Container App Environment."
  value       = module.container_app_environment.principal_id
}

output "identity_tenant_id" {
  description = "Tenant ID of the system-assigned identity on the Container App Environment."
  value       = module.container_app_environment.tenant_id
}

output "user_assigned_identity_id" {
  description = "Resource ID of the user-assigned identity attached to the Container App Environment."
  value       = module.user_assigned_identity.id
}

output "user_assigned_identity_principal_id" {
  description = "Principal ID of the user-assigned identity attached to the Container App Environment."
  value       = module.container_app_environment.user_assigned_identity_principal_ids["environment"]
}
