package testimpl

import (
	"context"
	"os"
	"strings"
	"testing"

	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/appcontainers/armappcontainers/v3"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestComposableComplete(t *testing.T, ctx types.TestContext) {
	subscriptionId := os.Getenv("ARM_SUBSCRIPTION_ID")

	if len(subscriptionId) == 0 {
		t.Fatal("ARM_SUBSCRIPTION_ID environment variable is not set")
	}

	cred, err := azidentity.NewDefaultAzureCredential(nil)
	if err != nil {
		t.Fatalf("failed to obtain a credential: %v", err)
	}

	environmentsClient, err := armappcontainers.NewManagedEnvironmentsClient(subscriptionId, cred, nil)
	if err != nil {
		t.Fatalf("failed to create environments client: %v", err)
	}

	resourceGroupName := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "resource_group_name")
	environmentName := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "container_app_environment_name")
	infrastructureResourceGroupName := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "infrastructure_resource_group_name")

	environment, err := environmentsClient.Get(context.TODO(), resourceGroupName, environmentName, nil)
	if err != nil {
		t.Fatalf("failed to get environment: %v", err)
	}

	t.Run("EnsureEnvironmentExists", func(t *testing.T) {
		assert.NotNil(t, environment.ManagedEnvironment, "Environment should exist")
	})

	t.Run("EnsureEnvironmentIsBoundToLogAnalyticsWorkspace", func(t *testing.T) {
		assert.Equal(t, *environment.Properties.AppLogsConfiguration.Destination, "log-analytics")
	})

	t.Run("EnsureConsumptionWorkloadProfile", func(t *testing.T) {
		require.NotNil(t, environment.Properties)
		require.Len(t, environment.Properties.WorkloadProfiles, 1)
		profile := environment.Properties.WorkloadProfiles[0]
		require.NotNil(t, profile)
		require.NotNil(t, profile.Name)
		require.NotNil(t, profile.WorkloadProfileType)
		assert.Equal(t, "Consumption", *profile.Name)
		assert.Equal(t, "Consumption", *profile.WorkloadProfileType)
		require.NotNil(t, environment.Properties.InfrastructureResourceGroup)
		assert.Equal(t, infrastructureResourceGroupName, *environment.Properties.InfrastructureResourceGroup)
	})

	t.Run("EnsureManagedIdentity", func(t *testing.T) {
		require.NotNil(t, environment.Identity)
		require.NotNil(t, environment.Identity.Type)
		assert.Equal(
			t,
			string(armappcontainers.ManagedServiceIdentityTypeSystemAssignedUserAssigned),
			strings.ReplaceAll(string(*environment.Identity.Type), " ", ""),
		)

		principalID := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "identity_principal_id")
		tenantID := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "identity_tenant_id")
		require.NotNil(t, environment.Identity.PrincipalID)
		require.NotNil(t, environment.Identity.TenantID)
		assert.Equal(t, *environment.Identity.PrincipalID, principalID)
		assert.Equal(t, *environment.Identity.TenantID, tenantID)

		userAssignedIdentityID := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "user_assigned_identity_id")
		userAssignedPrincipalID := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "user_assigned_identity_principal_id")
		assigned := userAssignedIdentityByID(environment.Identity.UserAssignedIdentities, userAssignedIdentityID)
		require.NotNil(t, assigned, "user-assigned identity %s should be on the environment", userAssignedIdentityID)
		require.NotNil(t, assigned.PrincipalID)
		assert.Equal(t, *assigned.PrincipalID, userAssignedPrincipalID)
	})
}

func userAssignedIdentityByID(identities map[string]*armappcontainers.UserAssignedIdentity, id string) *armappcontainers.UserAssignedIdentity {
	if assigned, ok := identities[id]; ok {
		return assigned
	}

	for key, assigned := range identities {
		if strings.EqualFold(key, id) {
			return assigned
		}
	}

	return nil
}

func TestComposableReadonlyComplete(t *testing.T, ctx types.TestContext) {
	TestComposableComplete(t, ctx)
}
