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

output "id" {
  description = "The ID of the Container App Environment."
  value       = azurerm_container_app_environment.environment.id
}

output "name" {
  description = "Name of the Container App Environment."
  value       = var.name
}

output "custom_domain_verification_id" {
  description = "The ID of the Custom Domain Verification for this Container App Environment."
  value       = azurerm_container_app_environment.environment.custom_domain_verification_id
}

output "default_domain" {
  description = "The default, publicly resolvable, name of this Container App Environment."
  value       = azurerm_container_app_environment.environment.default_domain
}

output "docker_bridge_cidr" {
  description = "The network addressing in which the Container Apps in this Container App Environment will reside in CIDR notation. This property only has a value when infrastructure_subnet_id is configured and will be a range within the CIDR of the Subnet."
  value       = azurerm_container_app_environment.environment.docker_bridge_cidr
}

output "platform_reserved_cidr" {
  description = "The IP range, in CIDR notation, that is reserved for environment infrastructure IP addresses. This property only has a value when infrastructure_subnet_id is configured and will be a range within the CIDR of the Subnet."
  value       = azurerm_container_app_environment.environment.platform_reserved_cidr
}

output "platform_reserved_dns_ip_address" {
  description = "The IP address from the IP range defined by platform_reserved_cidr that is reserved for the internal DNS server. This property only has a value when infrastructure_subnet_id is configured and will be a value within the CIDR of the Subnet."
  value       = azurerm_container_app_environment.environment.platform_reserved_dns_ip_address
}

output "static_ip_address" {
  description = "The static IP address assigned to the Container App Environment. This will be a Public IP unless internal_load_balancer_enabled is set to true, in which case an IP in the Internal Subnet will be reserved."
  value       = azurerm_container_app_environment.environment.static_ip_address
}
