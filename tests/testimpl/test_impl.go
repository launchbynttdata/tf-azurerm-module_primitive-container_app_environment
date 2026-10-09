package testimpl

import (
	"context"
	"os"
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
}

func TestComposableReadonlyComplete(t *testing.T, ctx types.TestContext) {
	TestComposableComplete(t, ctx)
}
