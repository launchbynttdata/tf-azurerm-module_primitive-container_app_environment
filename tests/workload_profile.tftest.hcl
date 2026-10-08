mock_provider "azurerm" {}

run "consumption_profile_plans" {
  command = plan

  variables {
    name                               = "example"
    resource_group_name                = "example-rg"
    location                           = "eastus2"
    log_analytics_workspace_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.OperationalInsights/workspaces/example"
    infrastructure_resource_group_name = "example-infra-rg"
    workload_profiles = [
      {
        name                  = "Consumption"
        workload_profile_type = "Consumption"
      }
    ]
  }

  assert {
    condition     = azurerm_container_app_environment.environment.infrastructure_resource_group_name == "example-infra-rg"
    error_message = "infrastructure_resource_group_name was not planned."
  }

  assert {
    condition = alltrue([
      for profile in azurerm_container_app_environment.environment.workload_profile :
      profile.name == "Consumption" && profile.workload_profile_type == "Consumption"
    ])
    error_message = "Consumption workload profile was not planned."
  }
}
