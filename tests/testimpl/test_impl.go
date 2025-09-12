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

	resourceGroupName := terraform.Output(t, ctx.TerratestTerraformOptions(), "resource_group_name")
	environmentName := terraform.Output(t, ctx.TerratestTerraformOptions(), "container_app_environment_name")

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
}
